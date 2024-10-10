import requests


def test_api_data_schema():
    url = "https://desafio-latam-213520764589.us-central1.run.app/data"
    response = requests.get(url)

    assert (
        response.status_code == 200
    ), f"Error: API responded with code {response.status_code}, expected 200"

    data = response.json()
    for item in data:
        assert "id" in item, f"'id' key is missing in item: {item}"
        assert isinstance(item["id"], str), f"'id' is not a string in item: {item}"

        assert "name" in item, f"'name' key is missing in item: {item}"
        assert isinstance(item["name"], str), f"'name' is not a string in item: {item}"

        assert "timestamp" in item, f"'timestamp' key is missing in item: {item}"
        assert isinstance(
            item["timestamp"], str
        ), f"'timestamp' is not a string in item: {item}"
