import boto3
import os
import time
import logging
import secrets
from urllib.parse import unquote_plus


logging.basicConfig(level=logging.INFO)

ssm = boto3.client("ssm")

mc_client = boto3.client("mediaconvert")
endpoint = mc_client.describe_endpoints()["Endpoints"][0]["Url"]
mc = boto3.client("mediaconvert", endpoint_url=endpoint)


def generate_hls_key():
    return secrets.token_hex(16)  # 16 bytes AES-128


def store_key(content_path, key_hex):
    param_name = f"/nexa/hls/{content_path}"
    ssm.put_parameter(
        Name=param_name,
        Value=key_hex,
        Type="SecureString",
        Overwrite=True
    )


def lambda_handler(event, context):
    try:
        record = event['Records'][0]
        bucket = record['s3']['bucket']['name']
        key = unquote_plus(record['s3']['object']['key'])
        logging.info(f"New upload detected: s3://{bucket}/{key}")

        content_path = key.rsplit('/', 1)[0]
        destination = f"s3://{os.environ['OUTPUT_BUCKET']}/{content_path}/hls/video"

        hls_key = generate_hls_key()
        store_key(content_path, hls_key)

        response = mc.create_job(
            Role=os.environ["MEDIACONVERT_ROLE"],
            Settings={
                "Inputs": [{
                    "FileInput": f"s3://{bucket}/{key}",
                    "AudioSelectors": {
                        "Audio Selector 1": {
                            "SelectorType": "TRACK",
                                            "Tracks": [1]
                        }
                    }
                }],
                "OutputGroups": [{
                    "Name": "Apple HLS",
                    "OutputGroupSettings": {
                        "Type": "HLS_GROUP_SETTINGS",
                        "HlsGroupSettings": {
                            "Destination": destination,
                            "DirectoryStructure": "SUBDIRECTORY_PER_STREAM",
                            "SegmentsPerSubdirectory": 10000,
                            "SegmentLength": 6,
                            "MinSegmentLength": 0,
                            "Encryption": {
                                "Type": "STATIC_KEY",
                                "EncryptionMethod": "AES128",
                                "StaticKeyProvider": {
                                    "StaticKeyValue": hls_key,
                                    "Url": f"{os.environ['CLOUDFRONT_DOMAIN_NAME']}/playback/hls-key/{content_path}",
                                    "KeyFormat": "identity",
                                    "KeyFormatVersions": "1"
                                }
                            }
                        }
                    },
                    "Outputs": [
                        make_output(1920, 1080, 6000000),
                        make_output(1280, 720, 3000000),
                        make_output(854, 480, 1500000),
                    ]
                }],
            }
        )
        logging.info(f"MediaConvert job submitted: {response['Job']['Id']}")

    except Exception as e:
        logging.error(f"Transcoding failed: {e}")
        raise


def make_output(width, height, bitrate):
    return {
        "NameModifier": f"_{height}p",
        "VideoDescription": {
            "Width": width,
            "Height": height,
            "CodecSettings": {
                "Codec": "H_264",
                "H264Settings": {
                    "RateControlMode": "QVBR",
                    "MaxBitrate": bitrate,
                    "QvbrSettings": {
                        "QvbrQualityLevel": 7
                    }
                }
            }
        },
        "AudioDescriptions": [{
            "AudioSourceName": "Audio Selector 1",
            "CodecSettings": {
                "Codec": "AAC",
                "AacSettings": {
                    "Bitrate": 128000,
                    "CodingMode": "CODING_MODE_2_0",
                    "SampleRate": 48000
                }
            }
        }],
        "ContainerSettings": {"Container": "M3U8"}
    }
