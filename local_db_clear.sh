#!/usr/bin/env bash

set -ex

if [ $1 = "dev" ]; then
  export DB_NAME="postgres"
elif [ $1 = "test" ]
then
  export DB_NAME="postgres_test"
else
  echo "try again"
  exit 1
fi

psql -c "create database ${DB_NAME};" -U postgres || true
psql -h 127.0.0.1 -U postgres -d $DB_NAME -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public;"
