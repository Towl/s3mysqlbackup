#!/bin/bash

VERSION=$1

docker pull google/cloud-sdk:alpine
docker build -t eu.gcr.io/warm-canto-276410/s3filebackup:latest .
docker build -t eu.gcr.io/warm-canto-276410/s3filebackup:$VERSION .
docker push eu.gcr.io/warm-canto-276410/s3filebackup:latest
docker push eu.gcr.io/warm-canto-276410/s3filebackup:$VERSION
