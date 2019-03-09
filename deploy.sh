#!/usr/bin/env bash

set -ex

rm -f .version app-generated.yaml

APPENGINE_ENV=$1

case $APPENGINE_ENV in
  prod|stg) ;;
    *) echo "invalid environment" && exit 1;;
esac

# ./compile_and_test.sh

git rev-parse HEAD >> .version
mix run --no-start infra/generate-appengine.exs --env $APPENGINE_ENV --out "./app-generated.yaml"

if [ $APPENGINE_ENV = "prod" ]; then
  gcloud app deploy "app-generated.yaml" --verbosity=info --promote --quiet
elif [ $APPENGINE_ENV = "stg" ]
then
  gcloud app deploy "app-generated.yaml" --verbosity=info --no-promote --quiet
else
  echo "try again"
fi

rm .version app-generated.yaml
