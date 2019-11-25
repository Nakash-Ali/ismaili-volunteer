#!/usr/bin/env bash

set -ex

MIX_ENV=$1 mix do ecto.create, ecto.migrate

MIX_ENV=$1 mix run --require ./priv/repo/seeds/prod/*.exs
MIX_ENV=$1 mix run --require ./priv/repo/seeds/dev/*.exs
