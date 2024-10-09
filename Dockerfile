FROM python:3.9-slim

WORKDIR /app

COPY challengelatam/API/requirements.txt .
RUN pip install -r requirements.txt

COPY challengelatam/API/ .

EXPOSE 8080
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8080"]
