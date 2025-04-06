# FastAPI PDF-to-EPUB Converter - Notes

## **1. PDF text extractions**

### Edge Cases:

- **PDF-uri cu layout complex**

- **Litere decorative la început de capitole**

## **2. EPUB Generation**

### Probleme:

- **Capitolele nu sunt detectate corect**
  - Soluție: Regex pentru pattern-uri de titluri (ex: `r"^CAPITOLUL \d+"`).
- **Lipsa cuprinsului (TOC)**
  - Soluție: Generez TOC din titlurile capitolelor cu `ebooklib`.

## **3. API Endpoints**

### Observații:

- `/upload` acceptă doar fișiere <5MB (limita implicită FastAPI).
  - Pentru fișiere mari, folosesc `streaming` (vezi [FastAPI docs](https://fastapi.tiangolo.com/tutorial/request-files/#uploadfile)).

## **4. AI Integration**

### Rezumate:

- **Token limit la OpenAI API** (4096 tokens pentru `gpt-3.5-turbo`).
  - Soluție: Trunchiez textul sau folosesc `map-reduce` pentru texte lungi.

## **5. Teste**

### PDF-uri de test:

- `simple_text.pdf` - merge perfect.
- `complex_layout.pdf` - necesită preprocesare cu `pdfplumber`.
