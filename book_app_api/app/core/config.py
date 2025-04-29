import os
from dotenv import load_dotenv

load_dotenv()

class Settings:
    AZURE_API_KEY = os.getenv("AZURE_API_KEY")

settings = Settings()
