#!/usr/bin/env bash

set -ex

(cd ./assets &&\
  npm install && npm prune && npm audit fix && npm dedupe)

(cd ./priv/commands &&\
  npm install && npm prune && npm audit fix && npm dedupe)
