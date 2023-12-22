#!/bin/bash
mkdir -p code
mkdir -p setup
cp ../jupyter-lab/setup/run-jupyter-lab.sh setup/

mkdir -p /home/$USER/.cache/huggingface

# If a dockerfile is specified, use it. Otherwise, default to "Dockerfile.ipynbs"
if [ -z "$1" ]; then
    dockerfile="Dockerfile.ipynbs"
else
    dockerfile=$1
fi

# The image tag should be the dockerfile name without the "Dockerfile." prefix
tag=$(echo $dockerfile | sed 's/Dockerfile.//')

echo "Building $tag from $dockerfile."
docker build \
    --build-arg USER=$USER \
    -f $dockerfile \
    -t $tag \
    .
