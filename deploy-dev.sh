#!/usr/bin/env bash

set -ex

./compile_and_test.sh

git rev-parse HEAD >> .version

gcloud app deploy app-dev.yaml --verbosity=info --no-promote --quiet

rm .version
