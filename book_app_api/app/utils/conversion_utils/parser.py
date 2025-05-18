from typing import Tuple, List
from ebooklib import epub
from app.utils.conversion_utils.clean_text import extract_clean_lines, detect_common_lines, merge_broken_lines
from app.utils.conversion_utils.epub_builder import finalize_chapter, finalize_part, add_to_toc
from app.utils.conversion_utils.patterns import matches_any_pattern, PART_PATTERNS, CHAPTER_PATTERNS

def pdf_to_epub_chapters(doc) -> Tuple[List[epub.EpubHtml], List]:
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
