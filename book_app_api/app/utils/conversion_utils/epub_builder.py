from app.utils.conversion_utils.cover_utils import extract_cover
from ebooklib import epub
from typing import List, Set, Tuple
import re
import os


def sanitize_filename(title: str) -> str:
    return re.sub(r'\W+', '_', title.strip())

def get_unique_filename(base_title: str, used: Set[str], counter: int, part_title: str = "") -> Tuple[str, int]:
    base = sanitize_filename(f"{part_title}_{base_title}" if part_title else base_title) or f"chapter_{counter}"
    filename = f"{base}.xhtml"
    while filename in used:
        counter += 1
        filename = f"{base}_{counter}.xhtml"
    used.add(filename)
    return filename, counter

def create_epub_html(title: str, filename: str, content: str, level: str = 'chapter') -> epub.EpubHtml:
    tag = 'h1' if level == 'part' else 'h2'
    html = epub.EpubHtml(title=title, file_name=filename, lang='en')
    html.content = f'<{tag}>{title}</{tag}><p>{content.replace("\n", "<br/>")}</p>'
    return html

def finalize_chapter(title: str, content: str, used_files: Set[str], counter: int, part_title: str = "") -> Tuple[epub.EpubHtml, int]:
    if not content.strip():
        return None, counter
    filename, counter = get_unique_filename(title, used_files, counter, part_title)
    chapter = create_epub_html(title, filename, content)
    return chapter, counter

def finalize_part(title: str, used_files: Set[str], counter: int) -> Tuple[epub.EpubHtml, int]:
    filename, counter = get_unique_filename(title, used_files, counter)
    part = create_epub_html(title, filename, "", level="part")
    return part, counter

def add_to_toc(toc: List, part_title: str, chapter: epub.EpubHtml):
    if part_title:
        for item in toc:
            if isinstance(item, tuple) and item[0].title == part_title:
                item[1].append(chapter)
                return
        toc.append((epub.EpubHtml(title=part_title, file_name="", lang='en'), [chapter]))
    else:
        toc.append(chapter)

def add_cover(doc, book: epub.EpubBook):
    try:
        cover_bytes = extract_cover(doc)
        if not cover_bytes:
            return
        
        cover_directory = os.path.join(os.path.dirname(__file__), "temp_covers")
        os.makedirs(cover_directory, exist_ok=True)
        cover_path = os.path.join(cover_directory, "cover.jpg")
        with open(cover_path, "wb") as f:
            f.write(cover_bytes)
        
        book.set_cover("images/cover.jpg", cover_bytes)

        cover_image_item = epub.EpubItem(
                    uid="cover-img",
                    file_name="images/cover.jpg",
                    media_type="image/jpeg",
                    content=cover_bytes
                )
        book.add_item(cover_image_item)

        existing_cover = None
        for item in book.items:
            if isinstance(item, epub.EpubHtml) and item.file_name == "cover.xhtml":
                existing_cover = item
                break

        if existing_cover:
            existing_cover.content = '''
            <html>
                <head><title>Cover</title></head>
                <body>
                    <div style="text-align: center;">
                        <img src="images/cover.jpg" alt="cover-img" style="max-width: 100%; height: auto;"/>
                    </div>
                </body>
            </html>
            '''
        else:
            cover_html = epub.EpubHtml(title="Coperta", file_name="cover.xhtml", lang='ro', uid='cover-html')
            cover_html.cont = '''
            <html>
                <head><title>Cover</title></head>
                <body>
                    <div style="text-align: center;">
                        <img src="images/cover.jpg" alt="cover-img" style="max-width: 100%; height: auto;"/>
                    </div>
                </body>
            </html>
            '''
            book.add_item(cover_html)

        return True

    except Exception as e:
        print(f"Eroare la adăugarea coperții: {str(e)}")

    return False

    