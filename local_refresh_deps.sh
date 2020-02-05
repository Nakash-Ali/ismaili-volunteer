#!/usr/bin/env bash

set -xeuf -o pipefail

./refresh_elixir_deps.sh
./refresh_npm_deps.sh
