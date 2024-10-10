import requests

def test_api_invalid_endpoint():
    url = "https://desafio-latam-213520764589.us-central1.run.app/invalid_endpoint"
    response = requests.get(url)
    
    assert response.status_code == 404, f"Error: Expected 404 for invalid endpoint, but got {response.status_code}"
