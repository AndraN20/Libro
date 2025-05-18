from app.api.controllers import book_controller, interaction_controller, progress_controller, user_controller
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.api import auth_controller, conversion, health_check
from app.core.database_config import Base, engine 
from app.services.gcs.scheduler_service import start_scheduler
import uvicorn

app = FastAPI(
    title="Book App API",
    description="API pentru Book App",
    version="1.0.0"
)

# Configurare CORS (pentru frontend)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

scheduler = start_scheduler()

@app.on_event("shutdown")
async def shutdown_event():
    scheduler.shutdown() 
    print("scheduler shutdown\n")

app.include_router(health_check.router)

app.include_router(
    book_controller.router,
    tags=["Book Operations"],
)

app.include_router(
    user_controller.router,
    tags=["User Operations"],
)

app.include_router(
    progress_controller.router,
    tags=["Progress Operations"],
)   

app.include_router(
    interaction_controller.router,
    tags=["Interaction Operations"],
)
    

app.include_router(
    conversion.router,
    tags=["PDF to EPUB Conversion"],
)

app.include_router(
    auth_controller.router,
    tags=["Authentication"]
)


if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)