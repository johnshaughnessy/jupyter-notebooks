#!/bin/bash

# Get the password from the first argument
JUPYTER_PASSWORD=$1
PORT=$2

# Generate the hashed password using Argon2
HASHED_PASSWORD=$(python3 -c "from argon2 import PasswordHasher; ph = PasswordHasher(); print(ph.hash('$JUPYTER_PASSWORD'))")

mkdir -p $HOME/.jupyter
cat <<EOF >$HOME/.jupyter/jupyter_server_config.json
{
  "IdentityProvider": {
    "hashed_password": "argon2:$HASHED_PASSWORD"
  }
}
EOF
# Start JupyterLab
PATH=$PATH:/usr/bin/node jupyter lab \
    --config=$HOME/.jupyter/jupyter_server_config.json \
    --no-browser \
    --port $2 \
    --ip 0.0.0.0
