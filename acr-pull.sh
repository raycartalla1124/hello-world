#!/bin/bash

# Configuration
ACR_NAME="helloapi"
REGISTRY_URL="$ACR_NAME.azurecr.io"
# Using $1 allows you to pass the image name as an argument
IMAGE_TAG=${1:-"helloapi.azurecr.io/helloworld:v1"}
TMP_DIR="$HOME/.docker/acr_pull_tmp"

echo "Step 1: Refreshing Azure Token for $ACR_NAME..."
TOKEN=$(az acr login --name $ACR_NAME --expose-token --query accessToken -o tsv)

echo "Step 2: Setting up isolated Docker config..."
mkdir -p $TMP_DIR
echo "{\"auths\": {\"$REGISTRY_URL\": {\"auth\": \"$(echo -n "00000000-0000-0000-0000-000000000000:$TOKEN" | base64 | tr -d '\n')\"}}}" > $TMP_DIR/config.json

echo "Step 3: Pulling image $IMAGE_TAG..."
DOCKER_CONFIG=$TMP_DIR docker pull $IMAGE_TAG

echo "Step 4: Cleaning up local credentials..."
rm -rf $TMP_DIR

echo "Done! Image pulled successfully."
