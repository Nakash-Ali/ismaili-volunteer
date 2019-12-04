#!/usr/bin/env bash

set -ex

PGPASSWORD=postgres psql -c "create database postgres;" -U postgres || true
PGPASSWORD=postgres psql -h 127.0.0.1 -U postgres -d "postgres" -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public;"
