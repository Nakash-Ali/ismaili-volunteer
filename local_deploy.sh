#!/usr/bin/env bash

set -ex

./refresh_elixir_deps.sh

./local_compile.sh
./local_test.sh

./deploy.sh $1
