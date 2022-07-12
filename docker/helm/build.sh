#!/bin/bash
set +x
set -e

# export AWS_DEFAULT_REGION=ap-southeast-1

echo Build docker image
docker build -t public.ecr.aws/f2u4s3o8/helm:latest . 

echo Docker login and push
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws/f2u4s3o8
docker push public.ecr.aws/f2u4s3o8/helm:latest
