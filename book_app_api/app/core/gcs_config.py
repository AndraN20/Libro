import os
from google.cloud import storage
from google.oauth2 import service_account
from dotenv import load_dotenv

load_dotenv()

class GCSSettings:
    GOOGLE_APPLICATION_CREDENTIALS = os.getenv("GOOGLE_APPLICATION_CREDENTIALS")

gcs_config = GCSSettings()

def get_gcs_client():
    credentials = service_account.Credentials.from_service_account_file(
        gcs_config.GOOGLE_APPLICATION_CREDENTIALS
    )
    return storage.Client(credentials=credentials)
