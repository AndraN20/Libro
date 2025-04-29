from typing import Optional
import ebooklib
from ebooklib import ITEM_DOCUMENT, ITEM_IMAGE
from ebooklib import epub
from pathlib import Path

epub_path = Path(__file__).parent.parent.parent / "test_files" / "test.epub"
covers_dir = Path(__file__).parent / "temp_covers"
covers_dir.mkdir(parents=True, exist_ok=True)

def get_epub_metadata(epub_file_path:str) -> Optional[dict]:
    try:
        book = epub.read_epub(epub_file_path)

        dc_metadata = {}
        for key in ['title', 'author', 'language', 'identifier','description','creator','identifier','subject','date']:
            metadata = list(book.get_metadata('DC', key))  
            if metadata:
                dc_metadata[key] = metadata[0][0]

        opf_metadata = {}
        for key in ['cover','description']:
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
        
        metadata = {
            'dc_metadata': dc_metadata,
            'opf_metadata': opf_metadata,
            # 'cover_image': cover_image
        }

        print(metadata)
        return metadata

    except Exception as e:
        print(f"Error reading EPUB file: {e}")
        return None
    
get_epub_metadata(str(epub_path))