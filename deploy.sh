#!/usr/bin/env bash

set -ex

mix compile --warnings-as-errors --force
mix test

gcloud app deploy --verbosity=info --promote  --quiet
