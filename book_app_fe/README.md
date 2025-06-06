# Flutter Book Reader App with FastAPI Backend

A cross-platform book reading application built with **Flutter** and powered by a **FastAPI** backend. The app allows users to read, store, and manage their eBook collections efficiently, with advanced features like format conversion and AI-powered summaries.

## Features

### 📚 Core Functionality

- Read ePub books with a customizable and responsive interface.
- Upload PDF books — they are automatically converted to ePub format for better compatibility.
- Local download and caching of converted ePub files.
- Cloud-based ePub storage (Google Cloud Storage) with only metadata stored in the backend database.

### 🔁 Format Conversion

- PDF to ePub conversion handled server-side via the FastAPI backend.
- Ensures seamless user experience across multiple file types.

### 🧠 Smart Summaries

- AI-generated summaries powered by backend services.
- **Per Chapter Summary:** Summarizes from the beginning of the chapter to the user's last read position.
- **Per Book Summary:** Summarizes the entire content read so far — useful when returning to a book after a long break.

## Tech Stack

- **Frontend:** Flutter
- **Backend:** FastAPI (Python)
- **Cloud Storage:** Google Cloud Storage
- **Database:** PostgreSQL

## Installation & Run

### Backend (FastAPI with Poetry)

1. Clone the repo:

   ```bash
   git clone https://github.com/your-username/your-repo.git
   cd your-repo/backend
   ```

2. Install dependencies using Poetry:

   ```bash
   poetry install
   ```

3. Run the server:
   ```bash
   poetry run uvicorn app.main:app --host 0.0.0.0 --port 8000
   ```

> 💡 This command exposes the backend server on all interfaces, useful for testing with real devices connected over Wi-Fi (e.g., via `adb connect 192.168.0.172:5555`).

---

### Frontend (Flutter)

1. Navigate to the frontend directory:

   ```bash
   cd ../frontend
   ```

2. Get dependencies:

   ```bash
   flutter pub get
   ```

3. Connect your physical device (optional):

   ```bash
   adb connect 192.168.0.172:5555
   ```

4. Run the app:
   ```bash
   flutter run
   ```

## Folder Structure

```
project-root/
├── book_app_api/         # FastAPI backend
├── book_app_fe/        # Flutter frontend
├── README.md
└── ...
```
