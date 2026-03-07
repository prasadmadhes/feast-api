from fastapi import FastAPI

app = FastAPI()

APP_NAME = "feast"
APP_VERSION = "0.1.0"
APP_DESCRIPTION = "Backend for restaurant order management system"


@app.get("/")
def welcome():
    return {"message": "Welcome to the Feast application!"}


@app.get("/health")
def health_check():
    return {"status": "ok"}


@app.get("/about")
def about():
    return {
        "name": APP_NAME,
        "version": APP_VERSION,
        "description": APP_DESCRIPTION,
    }
