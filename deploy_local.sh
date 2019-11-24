#!/usr/bin/env bash

set -ex

./refresh_elixir_deps.sh
./compile.sh
./test.sh
./deploy.sh $1;
