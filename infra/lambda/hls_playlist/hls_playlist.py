import boto3
from botocore.exceptions import ClientError
import os
import time
import hmac
import hashlib
import re

s3 = boto3.client("s3")
ssm = boto3.client("ssm")

BUCKET = os.environ["PLAYLIST_BUCKET"]
KEY_ENDPOINT = os.environ["KEY_ENDPOINT"]
CLOUDFRONT_DOMAIN_NAME = os.environ["CLOUDFRONT_DOMAIN_NAME"]
param = ssm.get_parameter(
    Name=os.environ["SIGNING_SECRET_NAME"],
    WithDecryption=True
)
SECRET = param["Parameter"]["Value"].encode()

TTL = 60

KEY_REGEX = re.compile(r'#EXT-X-KEY:METHOD=AES-128,URI="[^"]+"')
SEGMENT_REGEX = re.compile(r'^(?!#)(.+\.ts)$', re.MULTILINE)
VARIANT_REGEX = re.compile(r'^video_(\d+p)\.m3u8$', re.MULTILINE)

PLACEHOLDER_PATH = "placeholders/video-default"


def sign_key_url(scope: str) -> str:
    exp = int(time.time()) + TTL
    payload = f"{scope}:{exp}"

    sig = hmac.new(
        SECRET,
        payload.encode(),
        hashlib.sha256
    ).hexdigest()

    return f"{KEY_ENDPOINT}/{scope}?exp={exp}&sig={sig}"


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


def rewrite_master_playlist(playlist, content_path):
    prefix = f"/playlist/{content_path}/"

    return VARIANT_REGEX.sub(
        lambda m: prefix + m.group(1),
        playlist
    )


def rewrite_variant_playlist(playlist, content_path):
    signed_key_url = sign_key_url(content_path)

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
        content_path, variant = parse_request(proxy)
        filename = variant_to_filename(variant)

        obj, effective_path = load_playlist(BUCKET, content_path, filename)
        playlist = obj["Body"].read().decode("utf-8")

        if variant == "master":
            playlist = rewrite_master_playlist(playlist, effective_path)
        else:
            playlist = rewrite_variant_playlist(playlist, effective_path)

        return {
            "statusCode": 200,
            "headers": {
                "Content-Type": "application/vnd.apple.mpegurl",
                "Cache-Control": "private, max-age=5"
            },
            "body": playlist
        }

    except ValueError:
        return {"statusCode": 404}

    except ClientError:
        return {"statusCode": 404}

    except Exception as e:
        print("Playlist error:", e)
        return {"statusCode": 500}
