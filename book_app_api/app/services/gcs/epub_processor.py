from app.services.gcs.gcs_service import GCSService
from app.utils.epub_storage_utils import get_epub_metadata
from app.core.database_config import get_db
from app.services.book_service import BookService
from app.dto.book_dto import BookCreateDto


def get_metadata_value(metadata: dict, key: str, default: str = "") -> str:
    return (
        metadata.get('dc_metadata', {}).get(key)
        or metadata.get('opf_metadata', {}).get(key)
        or default
    )

def process_all_books(bucket_name: str):
    gcs = GCSService()
    blobs = gcs.list_epub_blobs(bucket_name)
    db = next(get_db())
    book_service = BookService(db)

    for blob in blobs:
        try:
            temp_path = gcs.download_blob_to_tempfile(bucket_name, blob.name)
            metadata = get_epub_metadata(temp_path)

            title = get_metadata_value(metadata, 'title', 'Unknown')
            author = get_metadata_value(metadata, 'creator', 'Unknown')


            if book_service.get_book_by_title_and_author(title, author):
                print(f"Carte deja existenta: {title} - {author}, se omite.")
                continue

            cover_data = None
            if 'cover_image_path' in metadata:
                with open(metadata['cover_image_path'], 'rb') as f:
                    cover_data = f.read()

            book = BookCreateDto(
                title=get_metadata_value(metadata, 'title', 'Unknown'),
                author=get_metadata_value(metadata, 'creator', 'Unknown'),
                genre=get_metadata_value(metadata, 'subject', 'Uncategorized'),
                description=get_metadata_value(metadata, 'description', 'No description available.'),
                date=get_metadata_value(metadata, 'date', 'Unknown'),
                language=get_metadata_value(metadata, 'language', 'Unknown'),
                book_url=f"https://storage.googleapis.com/{bucket_name}/{blob.name}",
                cover_data=cover_data
            )

            book_service.add_book(book)
            print(f"Carte adaugata: {title} - {author}")
        except Exception as e:
            print(f"error adding book: {e}")
            db.rollback()
    db.close()