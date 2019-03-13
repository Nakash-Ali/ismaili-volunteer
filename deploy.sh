#!/usr/bin/env bash

set -ex

rm -f .git-sha app-generated.yaml
test -z "$(git status --porcelain)"

GCLOUD_ENV=$1; shift;

case $GCLOUD_ENV in
  prod|stg) ;;
    *) echo "invalid environment" && exit 1;;
esac

./compile_and_test.sh

GIT_SHA=`git rev-parse HEAD`
GIT_SHA_SHORT=`git rev-parse --short HEAD`
GCLOUD_VERSION="${GIT_SHA_SHORT}-${GCLOUD_ENV}"

echo $GIT_SHA >> .git-sha
mix run --no-start infra/generate-appengine.exs --env $GCLOUD_ENV --out "./app-generated.yaml"

if [ $GCLOUD_ENV = "prod" ]; then
  gcloud app deploy "app-generated.yaml" --verbosity=info -v $GCLOUD_VERSION --promote --quiet "$@"
elif [ $GCLOUD_ENV = "stg" ]
then
  gcloud app deploy "app-generated.yaml" --verbosity=info -v $GCLOUD_VERSION --no-promote --quiet "$@"
else
  echo "try again"
fi

rm .git-sha app-generated.yaml
