import re
from typing import List

PART_PATTERNS = [
    r'^\s*(PARTEA|PART|partea|Partea|part|Part)\s+[IVXLCDM\d]+$', 
    r'^\s*(PART|part)\s*(First|Second|Third|Fourth|Fifth|Sixth|Seventh|Eighth|Ninth|Tenth)\s*$', 
    r'^\s*(PART|part)\s*(One|one|ONE|Two|two|TWO|Three|THREE|three|Four|FOUR|four|Five|FIVE|five)\s*$'
]
CHAPTER_PATTERNS = [r'^\s*(CAPITOLUL|Capitol|Capitolul|CAPITOL|Chapter|CHAPTER|chapter|capitol|capitolul)\s+[\w\d]+',
                    r'^\s*(PREFACE|Preface|preface|Prologue|PROLOGUE|prologue)\s*$',
                    r'^\s*(INTRODUCERE|Introducere|introducere)\s*$', 
                    r'^\s*(INTRODUCTION|Introduction|introduction)\s*$',
                    r'^\s*(Prologue|PROLOGUE|prologue)\s*$',
                    ] 

INTRODUCTION_PATTERNS = [r'^\s*(INTRODUCERE|Introducere|introducere)\s*$']
APPENDIX_PATTERNS = [r'^\s*(APENDICE|Apendice|apendice|Apendix|apendix)\s*$']
TABLE_OF_CONTENTS_PATTERNS = [r'^\s*(CUVÂNT|Cuvânt|cuvânt)\s+DESPRE\s+AUTOR\s*$']


def matches_any_pattern(line: str, patterns: List[str]) -> bool:
    return any(re.match(pat, line.strip()) for pat in patterns)
