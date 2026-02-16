from fastapi import FastAPI

app = FastAPI()


@app.get("/")
def welcome():
    return {"message": "Welcome to the Feast application!"}


@app.get("/health")
def health_check():
    return {"status": "ok"}
