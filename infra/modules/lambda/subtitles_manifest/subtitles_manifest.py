from auth.cognito import verify_token
import json
import os
import boto3
import pycountry

s3 = boto3.client("s3")
ssm = boto3.client("ssm")

BUCKET = os.environ["SUBTITLES_BUCKET"]
PLACEHOLDER_PATH = "placeholders/video-default"
USER_POOL_ISSUER = os.environ["USER_POOL_ISSUER"]


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
    try:
        auth_header = (
            event.get("headers", {}).get("authorization")
            or event.get("headers", {}).get("Authorization")
        )
        _ = verify_token(auth_header, USER_POOL_ISSUER)
    except Exception as e:
        return {
            "statusCode": 401,
            "body": json.dumps({"message": "Unauthorized"}),
        }

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
