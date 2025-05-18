import unicodedata
import re
from typing import List, Set
from collections import Counter
from app.utils.conversion_utils.patterns import PART_PATTERNS, CHAPTER_PATTERNS, INTRODUCTION_PATTERNS, APPENDIX_PATTERNS, TABLE_OF_CONTENTS_PATTERNS
from app.utils.conversion_utils.patterns import matches_any_pattern
import re
from typing import List
from collections import Counter

def should_merge(prev: str, curr: str) -> bool:
    # Nu merge dacă linia precedentă e goală sau titlu
    if not prev:
        return False
    if prev.endswith(('.', '?', '!', ':', '”', '"')) and curr[0].isupper():
        return False
    return True

# elimina endline urile din mijlocul propozitiei (apelata in parser ca sa elimine si endlineurile dintre pagini)
def merge_broken_lines(lines: List[str]) -> List[str]:
    merged = []
    buffer = ""

    for line in lines:
        line = line.strip()
        if not line:
            if buffer:
                merged.append(buffer)
                buffer = ""
            continue

        # Dacă linia e un titlu, o adăugăm ca atare
        if matches_any_pattern(line, PART_PATTERNS + CHAPTER_PATTERNS + INTRODUCTION_PATTERNS + APPENDIX_PATTERNS + TABLE_OF_CONTENTS_PATTERNS):
            if buffer:
                merged.append(buffer)
                buffer = ""
            merged.append(line)
            continue

        if buffer and should_merge(buffer, line):
            buffer += " " + line
        else:
            if buffer:
                merged.append(buffer)
            buffer = line

    if buffer:
        merged.append(buffer)

    return merged

def normalize_unicode(line: str) -> str:
    return unicodedata.normalize("NFKC", line)

def is_reasonable_text(line: str) -> bool:
    return bool(re.match(r'^[\x20-\x7E\u00A0-\u017F‘’“”„»«…—–\s]+$', line))

def clean_line(line: str) -> str:
    line = normalize_unicode(line.strip())
    if re.fullmatch(r'\d{1,4}', line):
        return ""
    return line if is_reasonable_text(line) else ""


def merge_hyphenated_words(lines: List[str]) -> List[str]:
    merged = []
    i = 0
    while i < len(lines):
        if lines[i].endswith('-') and i + 1 < len(lines):
            merged.append(lines[i][:-1] + lines[i + 1])
            i += 2
        else:
            merged.append(lines[i])
            i += 1
    return merged

def detect_common_lines(doc, threshold: int = 50) -> Set[str]:

    line_counts = Counter()
    for page in doc:
        for line in page.get_text("text").strip().splitlines():
            clean = line.strip()
            if clean:
                line_counts[clean] += 1
    return {line for line, count in line_counts.items() if count >= threshold}

def extract_clean_lines(page, common_lines: Set[str]) -> List[str]:
    raw_lines = page.get_text("text").strip().splitlines()
    lines = [clean_line(line) for line in raw_lines]
    lines = [line for line in lines if line and line not in common_lines]
    lines = merge_hyphenated_words(lines)
    return lines
