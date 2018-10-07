#!/usr/bin/env bash

set -ex

MIX_ENV=dev mix compile --warnings-as-errors --force
MIX_ENV=prod mix compile --warnings-as-errors --force
MIX_ENV=test mix compile --warnings-as-errors --force

mix test
