#!/usr/bin/env bash

set -ex

mix deps.get
mix deps.unlock --unused
mix deps.clean --unused

(cd ./assets &&\
  npm install && npm prune && npm audit fix && npm dedupe)

(cd ./priv/commands &&\
  npm install && npm prune && npm audit fix && npm dedupe)
