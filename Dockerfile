FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt .

RUN pip install -r requirements.txt

COPY challengelatam/API /app/API
COPY challengelatam/config /app/config

EXPOSE 8080

CMD ["uvicorn", "API.main:app", "--host", "0.0.0.0", "--port", "8080"]