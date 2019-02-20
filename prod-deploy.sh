#!/usr/bin/env bash

set -ex

./compile_and_test.sh

git rev-parse HEAD >> .version

gcloud app deploy prod-app.yaml --verbosity=info --promote --quiet

rm .version
