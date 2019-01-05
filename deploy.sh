#!/usr/bin/env bash

set -ex

./compile_and_test.sh

git rev-parse HEAD >> .version

gcloud app deploy --verbosity=info --promote  --quiet

rm .version
