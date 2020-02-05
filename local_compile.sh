#!/usr/bin/env bash

set -xeuf -o pipefail

MIX_ENV="dev" mix compile --warnings-as-errors --force
MIX_ENV="test" mix compile --warnings-as-errors --force
