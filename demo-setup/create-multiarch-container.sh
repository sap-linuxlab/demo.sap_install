#!/bin/bash

# see also https://danmanners.com/posts/2022-01-buildah-multi-arch/
# run buildah login quay.io before running this script

# Set your manifest name
export MANIFEST_NAME="multiarch-sapdemosetup"

# Set the required variables
export BUILD_PATH="."
export REGISTRY="quay.io"
export USER="mkoch-redhat"
export IMAGE_NAME="sapdemosetup"
export IMAGE_TAG="0.2.15"

# Create a multi-architecture manifest
buildah manifest create ${MANIFEST_NAME}:${IMAGE_TAG}

# Build your amd64 architecture container
buildah bud \
    --tag "${REGISTRY}/${USER}/${IMAGE_NAME}:${IMAGE_TAG}" \
    --manifest ${MANIFEST_NAME}:${IMAGE_TAG} \
    --arch amd64 \
    --layers=true \
    ${BUILD_PATH}

# Build your arm64 architecture container
buildah bud \
    --tag "${REGISTRY}/${USER}/${IMAGE_NAME}:${IMAGE_TAG}" \
    --manifest ${MANIFEST_NAME}:${IMAGE_TAG} \
    --arch arm64 \
    --layers=true \
    ${BUILD_PATH}

# Push the full manifest, with both CPU Architectures
buildah manifest push --all \
    ${MANIFEST_NAME}:${IMAGE_TAG} \
    "docker://${REGISTRY}/${USER}/${IMAGE_NAME}:${IMAGE_TAG}"

