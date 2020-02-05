#!/usr/bin/env bash

set -xeuf -o pipefail

(cd ./assets &&\
  npm install && npm prune && npm audit fix && npm dedupe)

(cd ./funcs &&\
  npm install && npm prune && npm audit fix && npm dedupe)

(cd ./redirect &&\
  npm install && npm prune && npm audit fix && npm dedupe)
