from datetime import datetime, timedelta
from apscheduler.schedulers.background import BackgroundScheduler
from app.services.gcs.epub_processor import process_all_books


def scheduled_task():
    print("processing books...")
    process_all_books("book_libraryy")
    print("books processed")

def start_scheduler():
    scheduler = BackgroundScheduler()
    scheduler.add_job(scheduled_task, 'interval', hours=24)  
    scheduler.start()
    print("scheduler started")
    return scheduler