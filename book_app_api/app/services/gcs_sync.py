import tempfile
from typing import Optional
from google.cloud import storage

class GCSService:
    def __init__(self):
        self.storage_client = storage.Client()

    def get_epub_metadata(self, bucket_name:str, blob_name:str) -> Optional[dict]:
        try:
            bucket = self.storage_client.bucket(bucket_name)
            blob = bucket.blob(blob_name)

            if not blob_name.lower().endswith('.epub'):
                raise ValueError("The file is not an EPUB file.")
            
            with tempfile.NamedTemporaryFile(suffix='.epub') as temp_file:
                blob.download_to_filename(temp_file.name)
                metadata = get_epub_metadata(temp_file.name)

            metadata['gcs_url'] = f"https://storage.googleapis.com/{bucket_name}/{blob_name}"
            metadata['file_name'] = blob_name
                
            return metadata
        except Exception as e:
            print(f"Error retrieving EPUB metadata: {e}")
            return None