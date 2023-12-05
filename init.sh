#!/bin/bash
mkdir -p code
mkdir -p setup
cp ../jupyter-lab/setup/run-jupyter-lab.sh setup/

mkdir -p /home/$USER/.cache/huggingface

docker build \
    --build-arg USER=$USER \
    -f Dockerfile.ipynbs \
    -t ipynbs \
    .
