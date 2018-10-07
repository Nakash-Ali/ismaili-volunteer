#!/usr/bin/env bash

set -ex

./compile_and_test.sh

gcloud app deploy --verbosity=info --promote  --quiet
