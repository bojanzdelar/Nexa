import json
import os
import boto3
import pycountry
import rsa
from botocore.signers import CloudFrontSigner
from datetime import datetime, timedelta


s3 = boto3.client("s3")
ssm = boto3.client("ssm")


BUCKET = os.environ["SUBTITLES_BUCKET"]
PLACEHOLDER_PATH = "placeholders/video-default"
CLOUDFRONT_URL = os.environ["CLOUDFRONT_URL"]
PUBLIC_KEY_ID = os.environ["PUBLIC_KEY_ID"]
PRIVATE_KEY_NAME = os.environ["PRIVATE_KEY_NAME"]
SIGNED_URL_TTL = 300


param = ssm.get_parameter(
    Name=PRIVATE_KEY_NAME,
    WithDecryption=True
)
PRIVATE_KEY_PEM = param["Parameter"]["Value"].encode()
PRIVATE_KEY = rsa.PrivateKey.load_pkcs1(PRIVATE_KEY_PEM)


def rsa_signer(message: bytes) -> bytes:
    return rsa.sign(message, PRIVATE_KEY, "SHA-1")


def sign_subtitle(key: str) -> str:
    signer = CloudFrontSigner(PUBLIC_KEY_ID, rsa_signer)

    expires_at = datetime.now() + timedelta(seconds=SIGNED_URL_TTL)

    url = f"{CLOUDFRONT_URL}/{key}"

    return signer.generate_presigned_url(
        url,
        date_less_than=expires_at,
    )


def handle_sign_request(event):
    qs = event.get("queryStringParameters") or {}
    key = qs.get("key")
    url = sign_subtitle(f"subtitles/{key}")

    return {
        "statusCode": 200,
        "headers": {
            "Content-Type": "application/json",
            "Cache-Control": "no-store",
        },
        "body": json.dumps({"url": url}),
    }


def list_subtitles(path: str):
    resp = s3.list_objects_v2(Bucket=BUCKET, Prefix=path)

    subtitles = []

    for obj in resp.get("Contents", []):
        key = obj["Key"]

        if not key.endswith(".vtt"):
            continue

        code = key.split("/")[-1].replace(".vtt", "")
        label = code.upper()

        lang = pycountry.languages.get(alpha_2=code)
        if lang:
            label = lang.name

        subtitles.append({
            "code": code,
            "label": label,
            "key": key.removeprefix("subtitles/")
        })

    return subtitles


def lambda_handler(event, context):
    raw_path = event.get("rawPath", "")

    if raw_path == "/subtitles/sign":
        return handle_sign_request(event)

    path = event.get("pathParameters") or {}
    content_type = path.get("type")
    content_id = path.get("id")
    qs = event.get("queryStringParameters") or {}

    if content_type == "movies":
        content_path = f"subtitles/movies/{content_id}/"

    elif content_type == "shows":
        s = int(qs["s"])
        e = int(qs["e"])
        content_path = f"subtitles/shows/{content_id}/s{s:02d}/e{e:02d}/"

    else:
        return {
            "statusCode": 400,
            "body": "Invalid subtitle type",
        }

    subtitles = (
        list_subtitles(content_path)
        or list_subtitles(f"subtitles/{PLACEHOLDER_PATH}/")
    )

    return {
        "statusCode": 200,
        "headers": {
            "Content-Type": "application/json",
            "Cache-Control": "private, max-age=300",
        },
        "body": json.dumps(subtitles),
    }
