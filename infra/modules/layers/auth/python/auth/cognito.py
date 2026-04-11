from jose import jwt
import requests

JWKS_CACHE = None


def get_jwks(issuer):
    global JWKS_CACHE
    if JWKS_CACHE is None:
        JWKS_CACHE = requests.get(f"{issuer}/.well-known/jwks.json").json()
    return JWKS_CACHE


def verify_token(auth_header, issuer):
    if not auth_header or not auth_header.startswith("Bearer "):
        raise Exception("Missing token")

    token = auth_header.split(" ")[1]

    headers = jwt.get_unverified_header(token)
    kid = headers["kid"]

    jwks = get_jwks(issuer)
    key = next(k for k in jwks["keys"] if k["kid"] == kid)

    payload = jwt.decode(
        token,
        key,
        algorithms=["RS256"],
        issuer=issuer,
        options={"verify_aud": False},
    )

    if payload.get("token_use") != "access":
        raise Exception("Not an access token")

    return payload
