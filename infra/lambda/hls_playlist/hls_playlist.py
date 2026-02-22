import boto3
import os
import time
import hmac
import hashlib
import re

s3 = boto3.client("s3")

BUCKET = os.environ["PLAYLIST_BUCKET"]
KEY_ENDPOINT = os.environ["KEY_ENDPOINT"]
CLOUDFRONT_DOMAIN_NAME = os.environ["CLOUDFRONT_DOMAIN_NAME"]
SECRET = os.environ["SIGNING_SECRET"].encode()

TTL = 60

KEY_REGEX = re.compile(
    r'#EXT-X-KEY:METHOD=AES-128,URI="[^"]+"'
)
SEGMENT_REGEX = re.compile(r'^(?!#)(.+\.ts)$', re.MULTILINE)


def sign_key_url(content_type, content_id):
    exp = int(time.time()) + TTL
    payload = f"{content_type}:{content_id}:{exp}"

    sig = hmac.new(
        SECRET,
        payload.encode(),
        hashlib.sha256
    ).hexdigest()

    return f"{KEY_ENDPOINT}/{content_type}/{content_id}?exp={exp}&sig={sig}"


def lambda_handler(event, context):
    path = event.get("pathParameters") or {}

    content_type = path["type"]
    content_id = path["id"]
    filename = path["filename"]  # video.m3u8 / video_1080p.m3u8...

    s3_key = f"{content_type}/{content_id}/hls/{filename}"

    obj = s3.get_object(Bucket=BUCKET, Key=s3_key)
    playlist = obj["Body"].read().decode("utf-8")

    if filename != "video.m3u8":
        signed_key_url = sign_key_url(content_type, content_id)
        playlist = KEY_REGEX.sub(
            f'#EXT-X-KEY:METHOD=AES-128,URI="{signed_key_url}"',
            playlist
        )

        cf_prefix = f"{CLOUDFRONT_DOMAIN_NAME}/{content_type}/{content_id}/hls/"
        playlist = SEGMENT_REGEX.sub(
            lambda m: cf_prefix + m.group(1),
            playlist
        )

    return {
        "statusCode": 200,
        "headers": {
            "Content-Type": "application/vnd.apple.mpegurl",
            "Cache-Control": "no-store"
        },
        "body": playlist
    }
