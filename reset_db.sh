#!/usr/bin/env bash

set -ex

psql -h 127.0.0.1 -U postgres -d $DB_NAME -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public;"

mix do ecto.create, ecto.migrate
mix run ./priv/repo/seeds/infrastructure_canada.exs

mix run priv/repo/test_seeds/accounts.exs
