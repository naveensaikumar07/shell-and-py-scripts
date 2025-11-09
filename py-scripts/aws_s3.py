#!/bin/python3
import boto3
from botocore.exceptions import NoCredentialsError
from pyfiglet import Figlet
f = Figlet(font='slant')
print(f.renderText('AWS S3'))

s3=boto3.client('s3')
response=s3.list_buckets()
bucket_name = response['Buckets'][0]['Name']
print(bucket_name)
print("="*50)

def upload_to_s3(local_file, bucket_name, s3_file):
    s3 = boto3.client('s3')

    try:
        s3.upload_file(local_file, bucket_name, s3_file)
        print("Upload Successful")
    except FileNotFoundError:
        print("The file was not found")
    except NoCredentialsError:
        print("Credentials not available")

if __name__ == "__main__":
    local_file_path = '/home/nsk/openmetal.pub'
    bucket_name = 'mybucketest007'
    s3_file_path = 'test/openmetal.pub'

    upload_to_s3(local_file_path, bucket_name, s3_file_path)