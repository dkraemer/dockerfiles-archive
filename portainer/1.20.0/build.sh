#!/bin/bash
if [ "$(uname -m)" != "x86_64" ]; then
    echo "Building this image is only supported on x86_64"
    exit 1
fi
export BUILD_ARCH=${BUILD_ARCH:-amd64}
docker build -t dkraemer/portainer:1.20.0-linux-${BUILD_ARCH} --build-arg BUILD_ARCH .
