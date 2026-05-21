# Flutter Book Reader App with FastAPI Backend

## Project Overview

The Flutter Book Reader App is built with a modern tech stack featuring Flutter for the frontend and FastAPI for the backend, with cloud storage integration for efficient eBook management.

This document provides a comprehensive overview of the project architecture, technologies used, and key features implemented or planned for implementation.

## Technology Stack

### Frontend

- **Flutter**: A UI toolkit from Google for building natively compiled applications for mobile, web, and desktop from a single codebase.
  - **Riverpod**: State management solution that provides dependency injection and reactive programming.
  - **Flutter HTML**: Renders HTML content within Flutter applications, used for displaying EPUB content.
  - **EPUBX**: Library for parsing and rendering EPUB files.
  - **Secure Storage**: For securely storing authentication tokens.
  - **Figma**: For app design and prototype - [https://www.figma.com/design/sgIwuIfkFwQs5lLd5FPJGz/Book-app?node-id=1-23&t=QDvtaFEUph3prSHs-1]

### Backend

- **FastAPI**: A modern, high-performance web framework for building APIs with Python based on standard Python type hints.
  - **SQLAlchemy**: SQL toolkit and Object-Relational Mapping (ORM) library.
  - **Alembic**: Database migration tool for SQLAlchemy.
  - **PyMuPDF (fitz)**: Library for PDF processing and conversion.
  - **EbookLib**: Library for creating and manipulating EPUB files.
  - **APScheduler**: Advanced Python scheduler for background tasks.

### Storage

- **Google Cloud Storage**: Cloud storage service for storing EPUB files.
  - Provides secure, scalable storage for the application's eBook collection.
  - Generates signed URLs for secure, time-limited access to files.

### Database

- **PostgreSQL**: Relational database for storing user data, book metadata, reading progress, and user interactions.
  - Stores relationships between users, books, and reading progress.
  - Maintains metadata while actual eBook files are stored in Google Cloud Storage.

## Core Features

### User Management

- **Authentication**: Secure user registration and login with JWT token-based authentication.
- **Profile Management**: Users can view and edit their profile information, including username and profile picture.
- **Reading Statistics**: Track reading progress across the user's library.

### Book Management

- **Library Organization**: Users can browse, search, and organize their eBook collection.
- **Book Details**: View comprehensive metadata about each book, including title, author, genre, and description.
- **Cover Display**: Books display their cover images for easy visual identification.

### Reading Experience

- **EPUB Reader**: Built-in EPUB reader with a clean, customizable interface.
- **Reading Progress Tracking**: Automatically saves and syncs reading position with the database.
- **Annotations and Interactions**: Support for highlights, bookmarks, and notes within books.

### Format Conversion

- **PDF to EPUB Conversion**: Server-side conversion of PDF files to EPUB format.
  - Improves reading experience by leveraging EPUB's reflowable text capabilities.
  - Extracts text, images, and structure from PDFs to create well-formatted EPUBs.
  - Preserves book covers during conversion when available.

### Cloud Integration

- **Cloud Storage**: Books are stored in Google Cloud Storage for efficient access and management.

## Data Model

### Key Entities

#### User

- Basic user information (username, email, password)
- Profile picture
- Relationship to reading progress and interactions

#### Book

- Metadata (title, author, genre, description, language, publication date)
- Cover image
- URL to the actual eBook file in cloud storage

#### Progress

- Tracks reading progress for each user-book combination
- Stores current position (percentage, EPUB CFI, character position)
- Reading status (not started, in progress, completed)
- Last read timestamp

#### Interaction

- User annotations within books (highlights, bookmarks, notes)
- Page number and position information
- Associated text content


### AI-Powered Summaries

- **Chapter Summaries**: AI-generated summaries of chapters from the beginning to the user's current position.
- **Book Summaries**: Comprehensive summaries of the entire book content read so far.
- **Context Refreshers**: Quick refreshers when returning to a book after a break.

### Enhanced Reading Experience

- **Customizable Typography**: Font size, type, and spacing adjustments.
- **Theme Options**: Light, dark, and sepia reading modes.

## Technical Implementation

### Backend Architecture

- **RESTful API**: Well-defined endpoints for all application features.
- **Database Migrations**: Managed through Alembic for version control of database schema.
- **Background Processing**: Scheduled tasks for maintenance and processing.

### Frontend Architecture

- **Feature-Based Structure**: Organized by domain features for maintainability.
- **Clean Architecture**: Separation of concerns with domain, data, and presentation layers.
- **Responsive Design**: Adapts to different screen sizes and orientations.

### Security Considerations

- **JWT Authentication**: Secure token-based authentication.
- **Secure Storage**: Sensitive information stored securely on device.
- **Signed URLs**: Time-limited access to cloud storage resources.

## Google Play Store Relevance

The Flutter Book Reader App addresses several key market needs that make it relevant for the Google Play Store:

1. **Cross-Platform Compatibility**: Works seamlessly across Android devices with a single codebase, ensuring consistent experience.

2. **Format Flexibility**: Supports multiple eBook formats through conversion, eliminating the need for users to manage multiple reading apps.

3. **Cloud Integration**: Modern cloud-based approach allows users to access their library from any device without manual syncing.

4. **AI-Enhanced Reading**: AI summaries feature provides a unique selling point not commonly found in reading apps.

6. **Performance Optimization**: Flutter's native performance combined with efficient backend processing ensures a smooth reading experience.

7. **Modern Design**: Clean, intuitive interface following material design principles for an engaging user experience.

## Conclusion

The Flutter Book Reader App with FastAPI Backend represents a modern approach to eBook reading applications, combining the power of Flutter's cross-platform capabilities with FastAPI's high-performance backend. The integration with Google Cloud Storage provides scalable and efficient file management, while the planned AI features will offer unique value to users.

This application stands out in the Google Play Store marketplace by addressing common pain points in existing eBook readers, such as format limitations, while providing an enhanced reading experience through its clean interface and innovative features.
