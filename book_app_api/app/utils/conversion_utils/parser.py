from io import BytesIO
from typing import Dict, Tuple, List
from ebooklib import epub
from app.utils.conversion_utils.clean_text import clean_line, extract_clean_lines, detect_common_lines, merge_broken_lines, merge_hyphenated_words, should_merge
from app.utils.conversion_utils.epub_builder import finalize_chapter, finalize_part, add_to_toc
from app.utils.conversion_utils.patterns import matches_any_pattern, PART_PATTERNS, CHAPTER_PATTERNS
from PIL import Image
import base64
import fitz

def preprocess_doc(fitz_doc: fitz.Document) -> List[Dict]:
    result = []

    for page in fitz_doc:
        page_dict = {
            "width": page.rect.width,
            "height": page.rect.height,
            "text": page.get_text(),
            "images": []
        }

        for img in page.get_images(full=True):
            bbox = page.get_image_bbox(img)
            if bbox:
                page_dict["images"].append({
                    "bbox": (bbox.x0, bbox.y0, bbox.x1, bbox.y1)
                })

        result.append(page_dict)

    return result

def is_illustrated_book(doc) -> bool:
    if not doc:
        return False

    full_page_image_pages = 0
    total_pages = len(doc)

    for page in doc:
        images = page.get("images", [])
        page_width = page.get("width")
        page_height = page.get("height")

        if not images or not page_width or not page_height:
            continue

        page_area = page_width * page_height
        for img in images:
            bbox = img.get("bbox")  # format: (x0, y0, x1, y1)
            if not bbox or len(bbox) != 4:
                continue

            x0, y0, x1, y1 = bbox
            image_area = abs((x1 - x0) * (y1 - y0))
            if image_area / page_area >= 0.9:
                full_page_image_pages += 1
                break  # only one full image per page needed

    return (full_page_image_pages / total_pages) >= 0.7

def has_images_and_text(doc) -> bool:
    total_images = 0
    has_text = False

    for page in doc:
        images = page.get("images", [])
        text = page.get("text", "")

        total_images += len(images)
        if text and text.strip():
            has_text = True

       
        if total_images >= 10 and has_text:
            return True

    return total_images >= 10 and has_text


def handle_text_only_pdf(doc) -> Tuple[List[epub.EpubHtml], List]:
    chapters, toc = [], []
    common_lines = detect_common_lines(doc)

    part_title = None
    chapter_title = ""
    chapter_content = ""
    used_files = set()
    counter = 1

    all_lines = []

    for page in doc:
        page_lines = extract_clean_lines(page, common_lines)
        all_lines.extend(page_lines)

    merged_lines = merge_broken_lines(all_lines)

    for line in merged_lines:
        if matches_any_pattern(line, PART_PATTERNS):
            chapter, counter = finalize_chapter(chapter_title or "Untitled Chapter", chapter_content, used_files, counter, part_title)
            if chapter:
                chapters.append(chapter)
                add_to_toc(toc, part_title, chapter)
            chapter_content = ""
            part_title = line.strip()
            part, counter = finalize_part(part_title, used_files, counter)
            chapters.append(part)
            toc.append((part, []))
            chapter_title = None

        elif matches_any_pattern(line, CHAPTER_PATTERNS):
            chapter, counter = finalize_chapter(chapter_title or "Untitled Chapter", chapter_content, used_files, counter, part_title)
            if chapter:
                chapters.append(chapter)
                add_to_toc(toc, part_title, chapter)
            chapter_title = line.strip()
            chapter_content = ""
        else:
            chapter_content += line + "\n"

    chapter, counter = finalize_chapter(chapter_title or "Untitled Chapter", chapter_content, used_files, counter, part_title)
    if chapter:
        chapters.append(chapter)
        add_to_toc(toc, part_title, chapter)

    return chapters, toc

def handle_illustrated_pdf(doc) -> Tuple[List[epub.EpubHtml], List]:
    
    chapter_title = "Untitled Chapter"
    used_files = set()
    counter = 1

    html_content = ""

    for i, page in enumerate(doc):
        pix = page.get_pixmap(dpi=150)
        img = Image.frombytes("RGB", [pix.width, pix.height], pix.samples)

        buffer = BytesIO()
        img.save(buffer, format="JPEG")
        encoded_image = base64.b64encode(buffer.getvalue()).decode("utf-8")

        html_content += f'''
        <div style="text-align:center; margin-bottom: 20px;">
            <img src="data:image/jpeg;base64,{encoded_image}" alt="Page {i + 1}" style="max-width:100%; height:auto;"/>
        </div>
        '''

    file_name = f"chapter_{counter}.xhtml"
    while file_name in used_files:
        counter += 1
        file_name = f"chapter_{counter}.xhtml"
    used_files.add(file_name)

    chapter = epub.EpubHtml(title=chapter_title, file_name=file_name, lang="en")
    chapter.content = html_content

    chapters = [chapter]
    toc = [ chapter] 

    return chapters, toc

def handle_text_and_images_pdf(doc) -> Tuple[List[epub.EpubHtml], List]:
    common_lines = detect_common_lines(doc)
    preprocessed_doc = preprocess_doc(doc)

    chapters, toc = [], []
    part_title = None
    chapter_title = ""
    chapter_content = ""
    used_files = set()
    counter = 1

    for page_index, page in enumerate(doc):
        page_dict = preprocessed_doc[page_index]
        elements = []

        # Extrage blocurile de text cu coordonate
        for block in page.get_text("blocks"):
            x0, y0, x1, y1, text, *_ = block
            raw_lines = text.strip().splitlines()

            # Curăță și reconstruiește blocul de text
            cleaned_lines = [clean_line(line) for line in raw_lines if line.strip()]
            cleaned_lines = [line for line in cleaned_lines if line not in common_lines]
            cleaned_lines = merge_hyphenated_words(cleaned_lines)

            # Aplică logică de concatenare
            buffer = ""
            for line in cleaned_lines:
                if matches_any_pattern(line, PART_PATTERNS + CHAPTER_PATTERNS):
                    if buffer:
                        elements.append(("text", y0, buffer.strip()))
                        buffer = ""
                    elements.append(("text", y0, line.strip()))
                elif should_merge(buffer, line):
                    buffer += " " + line
                else:
                    if buffer:
                        elements.append(("text", y0, buffer.strip()))
                    buffer = line
            if buffer:
                elements.append(("text", y0, buffer.strip()))

        # Adaugă imaginile din pagina actuală
        for img in page_dict.get("images", []):
            bbox = img.get("bbox")
            if bbox and len(bbox) == 4:
                y0 = bbox[1]
                elements.append(("image", y0, img))

        # Sortează totul după y (vertical)
        elements.sort(key=lambda x: x[1])

        # Construiește conținutul capitolului
        for elem_type, _, content in elements:
            if elem_type == "text":
                line = content
                if matches_any_pattern(line, PART_PATTERNS):
                    chapter, counter = finalize_chapter(chapter_title or "Untitled Chapter",
                                                        chapter_content, used_files, counter, part_title)
                    if chapter:
                        chapters.append(chapter)
                        add_to_toc(toc, part_title, chapter)
                    chapter_content = ""
                    part_title = line.strip()
                    part, counter = finalize_part(part_title, used_files, counter)
                    chapters.append(part)
                    toc.append((part, []))
                    chapter_title = None

                elif matches_any_pattern(line, CHAPTER_PATTERNS):
                    chapter, counter = finalize_chapter(chapter_title or "Untitled Chapter",
                                                        chapter_content, used_files, counter, part_title)
                    if chapter:
                        chapters.append(chapter)
                        add_to_toc(toc, part_title, chapter)
                    chapter_title = line.strip()
                    chapter_content = ""
                else:
                    chapter_content += line + "\n"

            elif elem_type == "image":
                bbox = content["bbox"]
                try:
                    pix = page.get_pixmap(clip=bbox, dpi=150)
                    if pix.width == 0 or pix.height == 0 or not pix.samples:
                        continue
                    img = Image.frombytes("RGB", [pix.width, pix.height], pix.samples)
                    buffer = BytesIO()
                    img.save(buffer, format="JPEG")
                    encoded_image = base64.b64encode(buffer.getvalue()).decode("utf-8")

                    img_tag = f'<div style="text-align:center; margin: 10px 0;">' \
                              f'<img src="data:image/jpeg;base64,{encoded_image}" ' \
                              f'style="max-width:100%; height:auto;"/></div>\n'
                    chapter_content += img_tag
                except Exception:
                    continue

    # Finalizează ultimul capitol
    chapter, counter = finalize_chapter(chapter_title or "Untitled Chapter", chapter_content, used_files, counter, part_title)
    if chapter:
        chapters.append(chapter)
        add_to_toc(toc, part_title, chapter)

    return chapters, toc




def pdf_to_epub_chapters(doc) -> Tuple[List[epub.EpubHtml], List]:
    structured_doc = preprocess_doc(doc)

    if is_illustrated_book(structured_doc):
        print("[INFO] Detected illustrated book (full-page images).")
        return handle_illustrated_pdf(doc)
    elif has_images_and_text(structured_doc):
        print("[INFO] Detected book with both images and text.")
        return handle_text_and_images_pdf(doc)
    else:
        print("[INFO] Detected text-only book.")
        return handle_text_only_pdf(doc)
