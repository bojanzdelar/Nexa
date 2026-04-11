import time
import hmac
import hashlib


def _build_payload(scope: str, exp: int) -> str:
    return f"{scope}:{exp}"


def _sign_payload(payload: str, secret: bytes) -> str:
    return hmac.new(
        secret,
        payload.encode(),
        hashlib.sha256
    ).hexdigest()


def sign_key_url(scope: str, base_url: str, ttl: int, secret: bytes) -> str:
    exp = int(time.time()) + ttl
    payload = _build_payload(scope, exp)
    sig = _sign_payload(payload, secret)

    return f"{base_url}/{scope}?exp={exp}&sig={sig}"


def validate_signed_url(scope: str, exp: str, sig: str, secret: bytes) -> bool:
    if not scope or not exp or not sig:
        return False

    try:
        exp_int = int(exp)
    except (TypeError, ValueError):
        return False

    if time.time() > exp_int:
        return False

    payload = _build_payload(scope, exp_int)
    expected = _sign_payload(payload, secret)

    return hmac.compare_digest(expected, sig)
