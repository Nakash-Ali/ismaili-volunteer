#!/usr/bin/env bash

set -e
# set -x

# "Include" directive for app-specific config files
LINE="Include config.d/*"

# Automatically insert "Include" directive in user's ssh config file
ROOT_SSH_CONFIG="$HOME/.ssh/config"
grep -qF "$LINE" "$ROOT_SSH_CONFIG" || \
sed -i '.old' '1s=^='"$LINE"'\
\
=' $ROOT_SSH_CONFIG

# Make app-specific config directory
mkdir -p ~/.ssh/config.d

# Copy all SSH files in app to user's ssh config.d dir
cp -a ./ops/ssh/. ~/.ssh/config.d/
