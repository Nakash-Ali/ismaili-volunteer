#!/usr/bin/env bash

set -ex

export MIX_ENV="${MIX_ENV:-$1}";

if [ $MIX_ENV = "dev" ]; then
  export DB_NAME="postgres"
elif [ $MIX_ENV = "test" ]
then
  export DB_NAME="postgres_test"
else
  echo "try again"
  exit 1
fi

psql -c "create database ${DB_NAME};" -U postgres || true
psql -h 127.0.0.1 -U postgres -d $DB_NAME -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public;"

mix do ecto.create, ecto.migrate
mix run ./priv/repo/seeds/hardcoded_infrastructure.exs

mix run priv/repo/test_seeds/accounts.exs
