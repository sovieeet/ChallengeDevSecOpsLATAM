import requests
from datetime import datetime


def test_api_exposes_data():
    url = "https://desafio-latam-213520764589.us-central1.run.app/data"

    response = requests.get(url)

    assert (
        response.status_code == 200
    ), f"Error: API responded with code {response.status_code}, expected 200"

    data = response.json()
    assert len(data) > 0, "API isn't returning data"

    max_response_time = 3  # seconds
    assert (
        response.elapsed.total_seconds() < max_response_time
    ), "API response time is too long"

    for item in data:
        assert "timestamp" in item, f"'timestamp' key is missing in item: {item}"

        try:
            datetime.fromisoformat(item["timestamp"])
        except ValueError:
            raise AssertionError(
                f"'timestamp' doesn't have a valid ISO format in item: {item}"
            )

    print("Test passed: The API is exposing data correctly and meets all conditions.")


if __name__ == "__main__":
    test_api_exposes_data()
