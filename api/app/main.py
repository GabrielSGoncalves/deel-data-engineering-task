from fastapi import FastAPI
from .routers import router

app = FastAPI(
    title="ACME Analytics API",
    description="API for retrieving analytics data from ACME delivery operations",
    version="1.0.0",
)

app.include_router(router)


@app.get("/health")
def health_check():
    return {"status": "healthy"}
