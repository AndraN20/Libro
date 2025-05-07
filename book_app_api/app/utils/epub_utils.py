from typing import Optional
import ebooklib
from ebooklib import ITEM_DOCUMENT, ITEM_IMAGE
from ebooklib import epub
from pathlib import Path

covers_dir = Path(__file__).parent / "temp_covers"
covers_dir.mkdir(parents=True, exist_ok=True)

def get_epub_metadata(epub_file_path:str) -> Optional[dict]:
    try:
        book = epub.read_epub(epub_file_path)

        dc_metadata = {}
        for key in ['title', 'author', 'language', 'identifier','description','creator','identifier','subject','date','cover']:
            metadata = list(book.get_metadata('DC', key))  
            if metadata:
                dc_metadata[key] = metadata[0][0]

        opf_metadata = {}
        for key in ['title', 'author', 'language', 'identifier','description','creator','identifier','subject','date','cover']:
            metadata = list(book.get_metadata('OPF', key))  
            if metadata: 
                print(f"Metadata for '{key}': {metadata}")
                opf_metadata[key] = metadata
        
        cover_image = None
        if 'cover' in opf_metadata:
            cover_entry = opf_metadata['cover'][0][1]
            cover_id = cover_entry.get('content', )
            cover_item = book.get_item_with_id(cover_id)
            if cover_item:
                cover_image = cover_item.get_content()
            else:
                print(f"Cover item with id '{cover_id}' not found.")
        
        if cover_image:
            cover_path = covers_dir / "cover.jpg"
            with open(cover_path, "wb") as f:
                f.write(cover_image)
            print(f"Cover image saved at: {cover_path}")


        metadata = {
            'dc_metadata': dc_metadata,
            'opf_metadata': opf_metadata,
            'cover_image_path': str(cover_path) if cover_image else None
        }

        return metadata

    except Exception as e:
        print(f"Error reading EPUB file: {e}")
        return None
    