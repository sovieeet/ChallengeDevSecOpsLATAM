import requests

def test_health_check():
    url = "https://fastapi-app-213520764589.us-central1.run.app/health"
    response = requests.get(url)
    
    assert response.status_code == 200, f"Error: Expected 200, got {response.status_code}"
    assert response.json() == {"status": "ok"}, f"Unexpected response from health check endpoint: {response.json()}"
