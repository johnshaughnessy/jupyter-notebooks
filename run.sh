#!/bin/bash

# If a dockerfile is specified, use it. Otherwise, default to "Dockerfile.ipynbs"
if [ -z "$1" ]; then
    dockerfile="Dockerfile.ipynbs"
else
    dockerfile=$1
fi

# The image tag should be the dockerfile name without the "Dockerfile." prefix
tag=$(echo $dockerfile | sed 's/Dockerfile.//')

echo "Stopping $tag if it is running."
docker stop $tag || true
sleep 1

docker network create osai-bridge || true

echo "Ensuring that the code and setup directories are owned by the container user."
echo "This command may require sudo privileges."
# TODO: There should be a better way to do this.
# sudo chown -R 1000:1000 ./code ./setup /home/$USER/.cache/huggingface

echo
read -sp "Enter password for Jupyter Lab: " JUPYTER_PASSWORD
echo

echo "Running $tag."

docker run \
    --rm \
    --gpus all \
    -d \
    -it \
    --name $tag \
    --network osai-bridge \
    --publish 7004:7004 \
    --mount type=bind,source="$(pwd)"/code,target=/home/"$USER"/code \
    --mount type=bind,source="$(pwd)"/setup,target=/setup \
    --mount type=bind,source=/home/$USER/.cache/huggingface,target=/home/$USER/.cache/huggingface \
    --mount type=bind,source=/home/$USER/.cache/huggingface/hub/,target=/home/$USER/.cache/huggingface/hub/ \
    $tag \
    /setup/run-jupyter-lab.sh "$JUPYTER_PASSWORD" 7004
