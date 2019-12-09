#!/usr/bin/env bash

set -ex

./refresh_elixir_deps.sh

./local_compile_and_test.sh

./deploy.sh $1
