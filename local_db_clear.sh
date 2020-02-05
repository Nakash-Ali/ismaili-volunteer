#!/usr/bin/env bash

set -xeuf -o pipefail

PGPASSWORD=postgres psql -h 127.0.0.1 -U postgres -c "create database postgres;" || true
PGPASSWORD=postgres psql -h 127.0.0.1 -U postgres -d "postgres" -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public;"
