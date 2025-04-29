# from fastapi import APIRouter
# from pdfminer.high_level import extract_text
# import os 
# from fastapi.responses import PlainTextResponse
# import ebooklib
# from ebooklib import epub
# from fastapi.responses import FileResponse

# router = APIRouter()

# PDF_PATH = "test.pdf" 

# @router.get("/a", response_class=FileResponse)
# async def show_pdf_text():
#     try:
    
#         if not os.path.exists(PDF_PATH):
#             return "eroare: cale gresita catre pdf"
        
  
#         text = extract_text(PDF_PATH)
#         book = epub.EpubBook()

#         book.set_title("My Book")
#         book.set_language("en")
#         book.add_author("Author Name")
#         book.set_identifier("id123456")
        

#         c1 = epub.EpubHtml(title="Intro", file_name="chap_01.xhtml", lang="hr")
#         c1.content = (
#             "<h1>Intro heading</h1>"
#             "<p>Zaba je skocila u baru.</p>"
#         )

       

#         # add chapter
#         book.add_item(c1)
#         # add image
  

#         # define Table Of Contents
#         book.toc = (
#             epub.Link("chap_01.xhtml", "Introduction", "intro"),
#             (epub.Section("Simple book"), (c1,)),
#         )

#         # add default NCX and Nav file
#         book.add_item(epub.EpubNcx())
#         book.add_item(epub.EpubNav())

#         # define CSS style
#         style = "BODY {color: white;}"
#         nav_css = epub.EpubItem(
#             uid="style_nav",
#             file_name="style/nav.css",
#             media_type="text/css",
#             content=style,
#         )

#         # add CSS file
#         book.add_item(nav_css)

#         # basic spine
#         book.spine = ["nav", c1]

#         # write to the file
#         epub.write_epub("test.epub", book, {})

#         # Return the generated EPUB file as a downloadable response
#         return FileResponse("test.epub", media_type="application/epub+zip", filename="test.epub")
        
#     except Exception as e:
#         return f"eroare la procesare pdf: {str(e)}"