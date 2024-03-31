#!/bin/bash

docker pull google/cloud-sdk:alpine
docker build -t europe-west6-docker.pkg.dev/warm-canto-276410/tms-docker/s3-mysql-backup:latest .
docker push europe-west6-docker.pkg.dev/warm-canto-276410/tms-docker/s3-mysql-backup:latest
