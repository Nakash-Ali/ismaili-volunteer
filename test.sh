#!/usr/bin/env bash

set -ex

MIX_ENV=test ./reset_db_local.sh
mix test
