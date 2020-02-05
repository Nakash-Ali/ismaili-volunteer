#!/usr/bin/env bash

set -xeuf -o pipefail

mix deps.get
mix deps.unlock --unused
mix deps.clean --unused
