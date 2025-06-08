from google.cloud import storage
from google.oauth2 import service_account
from datetime import timedelta
import os
from urllib.parse import urlparse

def extract_blob_name(book_url: str) -> str:
    parsed = urlparse(book_url)
    path = parsed.path.lstrip("/")  
    parts = path.split("/", 1)     
    return parts[1] if len(parts) == 2 else ""  


CREDENTIALS_PATH = os.getenv("GOOGLE_APPLICATION_CREDENTIALS")
BUCKET_NAME = "book_libraryy"

credentials = service_account.Credentials.from_service_account_file(CREDENTIALS_PATH)
client = storage.Client(credentials=credentials)

def generate_signed_url_from_full_url(book_url: str, expiration_minutes: int = 60) -> str:
    blob_name = extract_blob_name(book_url)
    bucket = client.bucket(BUCKET_NAME)
    blob = bucket.blob(blob_name)
    return blob.generate_signed_url(
        version="v4",
        expiration=timedelta(minutes=expiration_minutes),
        method="GET",
    )

