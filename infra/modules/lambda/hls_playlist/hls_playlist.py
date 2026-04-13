from auth.cloudfront import generate_cf_cookies
from auth.signing import sign_key_url
import boto3
from botocore.exceptions import ClientError
import os
import re
import rsa
from jose import jwt
from urllib.parse import urlparse

s3 = boto3.client("s3")
ssm = boto3.client("ssm")

BUCKET = os.environ["PLAYLIST_BUCKET"]
KEY_ENDPOINT = os.environ["KEY_ENDPOINT"]
CLOUDFRONT_DOMAIN_NAME = os.environ["CLOUDFRONT_DOMAIN_NAME"]
PUBLIC_KEY_ID = os.environ["PUBLIC_KEY_ID"]
PRIVATE_KEY_NAME = os.environ["PRIVATE_KEY_NAME"]

param_private_key = ssm.get_parameter(
    Name=PRIVATE_KEY_NAME,
    WithDecryption=True
)
PRIVATE_KEY_PEM = param_private_key["Parameter"]["Value"].encode()
PRIVATE_KEY = rsa.PrivateKey.load_pkcs1(PRIVATE_KEY_PEM)

param_playlist_secret = ssm.get_parameter(
    Name=os.environ["PLAYLIST_SIGNING_SECRET_NAME"],
    WithDecryption=True
)
PLAYLIST_SECRET = param_playlist_secret["Parameter"]["Value"].encode()

param_segment_secret = ssm.get_parameter(
    Name=os.environ["SEGMENT_SIGNING_SECRET_NAME"],
    WithDecryption=True
)
SEGMENT_SECRET = param_segment_secret["Parameter"]["Value"].encode()

CF_COOKIE_TTL_SECONDS = 10800  # 3 hours
KEY_URL_TTL_SECONDS = 60

KEY_REGEX = re.compile(r'#EXT-X-KEY:METHOD=AES-128,URI="[^"]+"')
SEGMENT_REGEX = re.compile(r'^(?!#)(.+\.ts)$', re.MULTILINE)
VARIANT_REGEX = re.compile(r'^video_(\d+p)\.m3u8$', re.MULTILINE)

PLACEHOLDER_PATH = "placeholders/video-default"


def parse_request(proxy: str):
    parts = proxy.split("/")

    if parts[0] == "shows" and len(parts) >= 4:
        content_path = f"shows/{parts[1]}/{parts[2]}/{parts[3]}"
        variant = parts[4] if len(parts) > 4 else "master"
        return content_path, variant

    if parts[0] != "shows" and len(parts) >= 2:
        content_path = f"{parts[0]}/{parts[1]}"
        variant = parts[2] if len(parts) > 2 else "master"
        return content_path, variant

    raise ValueError("Invalid path")


def variant_to_filename(variant: str) -> str:
    if variant == "master":
        return "video.m3u8"

    if variant.endswith("p"):
        return f"video_{variant}.m3u8"

    raise ValueError("Invalid variant")


def load_playlist(bucket, content_path, filename):
    candidates = [(f"{content_path}/hls/{filename}", content_path),
                  (f"{PLACEHOLDER_PATH}/hls/{filename}", PLACEHOLDER_PATH)]

    for key, effective_path in candidates:
        try:
            obj = s3.get_object(Bucket=bucket, Key=key)
            return obj, effective_path
        except ClientError as e:
            if e.response["Error"]["Code"] != "NoSuchKey":
                raise

    raise ClientError({"Error": {"Code": "NoSuchKey"}}, "GetObject")


def rewrite_master_playlist(playlist, content_path, token):
    prefix = f"/playlists/{content_path}/"

    return VARIANT_REGEX.sub(
        lambda m: f"{prefix}{m.group(1)}?token={token}",
        playlist
    )


def rewrite_variant_playlist(playlist, content_path):
    signed_key_url = sign_key_url(
        content_path, KEY_ENDPOINT, KEY_URL_TTL_SECONDS, SEGMENT_SECRET)

    playlist = KEY_REGEX.sub(
        f'#EXT-X-KEY:METHOD=AES-128,URI="{signed_key_url}"',
        playlist
    )

    cf_prefix = f"{CLOUDFRONT_DOMAIN_NAME}/{content_path}/hls/"
    playlist = SEGMENT_REGEX.sub(
        lambda m: cf_prefix + m.group(1),
        playlist
    )

    return playlist


def lambda_handler(event, context):
    try:
        proxy = event.get("pathParameters", {}).get("proxy", "")
        qs = event.get("queryStringParameters") or {}
        token = qs.get("token")

        if not token:
            return {"statusCode": 401}

        try:
            payload = jwt.decode(token, PLAYLIST_SECRET, algorithms=["HS256"])
        except Exception:
            return {"statusCode": 401}

        request_path = f"/playlists/{proxy}"

        if not (
            request_path.startswith(payload["path"]) or
            request_path.startswith("/playlists/placeholders/")
        ):
            return {"statusCode": 403}

        content_path, variant = parse_request(proxy)
        filename = variant_to_filename(variant)

        obj, effective_path = load_playlist(BUCKET, content_path, filename)
        playlist = obj["Body"].read().decode("utf-8")

        if variant == "master":
            playlist = rewrite_master_playlist(playlist, effective_path, token)
        else:
            playlist = rewrite_variant_playlist(playlist, effective_path)

        headers = {
            "Content-Type": "application/vnd.apple.mpegurl",
            "Cache-Control": "private, max-age=5"
        }

        response = {
            "statusCode": 200,
            "headers": headers,
            "body": playlist
        }

        if variant == "master":
            cf_cookies = generate_cf_cookies(
                domain=CLOUDFRONT_DOMAIN_NAME, content_path=effective_path, private_key=PRIVATE_KEY, public_key_id=PUBLIC_KEY_ID, ttl=CF_COOKIE_TTL_SECONDS)

            host = urlparse(
                CLOUDFRONT_DOMAIN_NAME).hostname or CLOUDFRONT_DOMAIN_NAME
            parent_domain = "." + ".".join(host.split(".")[1:])

            response["cookies"] = [
                f"CloudFront-Policy={cf_cookies['CloudFront-Policy']}; Path=/; Domain={parent_domain}; Secure; HttpOnly; SameSite=None",
                f"CloudFront-Signature={cf_cookies['CloudFront-Signature']}; Path=/; Domain={parent_domain}; Secure; HttpOnly; SameSite=None",
                f"CloudFront-Key-Pair-Id={cf_cookies['CloudFront-Key-Pair-Id']}; Path=/; Domain={parent_domain}; Secure; HttpOnly; SameSite=None",
            ]

        return response

    except ValueError:
        return {"statusCode": 404}

    except ClientError:
        return {"statusCode": 404}

    except Exception as e:
        print("Playlist error:", e)
        return {"statusCode": 500}
