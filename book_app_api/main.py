from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.api import conversion, health_check, summaries
from app.core.database import Base, engine 
import uvicorn
import sys

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


app.include_router(health_check.router)

# app.include_router(
#     conversion.router,
#     tags=["PDF Operations"]
# )

# app.include_router(
#     summaries.router,
#     tags=["Summarization"],
# )

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)