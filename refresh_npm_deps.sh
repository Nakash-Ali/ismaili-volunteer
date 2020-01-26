#!/usr/bin/env bash

set -ex

(cd ./assets &&\
  npm install && npm prune && npm audit fix && npm dedupe)

(cd ./funcs &&\
  npm install && npm prune && npm audit fix && npm dedupe)
