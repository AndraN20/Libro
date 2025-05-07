import tempfile
from google.cloud import storage

class GCSService:
    def __init__(self):
        self.client = storage.Client()

    def list_epub_blobs(self, bucket_name: str):
        bucket = self.client.bucket(bucket_name)
        return [blob for blob in bucket.list_blobs() if blob.name.lower().endswith('.epub')]

    def download_blob_to_tempfile(self, bucket_name: str, blob_name: str) -> str:
        bucket = self.client.bucket(bucket_name)
        blob = bucket.blob(blob_name)

        temp_file = tempfile.NamedTemporaryFile(suffix=".epub", delete=False)
        blob.download_to_filename(temp_file.name)
        return temp_file.name
