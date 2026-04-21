import os


def lambda_handler(event, context):
    headers = event.get("headers", {}) or {}

    secret = headers.get("x-origin-secret") or headers.get("X-Origin-Secret")
    expected = os.environ.get("ORIGIN_SECRET")

    return {
        "isAuthorized": secret == expected
    }
