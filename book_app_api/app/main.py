from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.api import conversion, health_check  # Importăm router-ul de conversie

app = FastAPI(
    title="PDF Text Extractor",
    description="Un serviciu simplu pentru extragerea textului din PDF-uri",
    version="0.1.0"
)

# Configurare CORS (pentru frontend)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include router-ul de health check
app.include_router(health_check.router)

# Include router-ul de conversie PDF
app.include_router(
    conversion.router,
    prefix="/api/v1/pdf",
    tags=["PDF Operations"]
)

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)