#!/usr/bin/env bash

set -xeuf -o pipefail

./local_compile.sh

./local_db_clear.sh test
./local_db_init.sh test

mix test
