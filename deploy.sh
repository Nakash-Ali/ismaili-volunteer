#!/usr/bin/env bash

set -ex

rm -f git-sha app-generated.yaml

GCLOUD_ENV=$1;

case $GCLOUD_ENV in
  prod|stg) ;;
    *) echo "invalid environment" && exit 1;;
esac

export GCLOUD_ENV

mix deps.unlock --unused
mix deps.clean --unused

if [ $GCLOUD_ENV = "prod" ]; then
  test -z "$(git status --porcelain)"
fi

export GIT_SHA=`git rev-parse HEAD`
export GIT_SHA_SHORT=`git rev-parse --short HEAD`
export GCLOUD_VERSION="${GCLOUD_ENV}-${GIT_SHA_SHORT}"
export GCLOUD_PROJECT="ismailivolunteer-201223"
export GCLOUD_TARGET_HOST="${GCLOUD_VERSION}-dot-${GCLOUD_PROJECT}.appspot.com"

echo $GIT_SHA >> git-sha

elixir infra/generate-appengine.exs --env $GCLOUD_ENV --out "./app-generated.yaml"

./compile_and_test.sh

if [ $GCLOUD_ENV = "prod" ]; then
  gcloud app deploy "app-generated.yaml" --verbosity=info --project=$GCLOUD_PROJECT -v $GCLOUD_VERSION --promote --quiet
elif [ $GCLOUD_ENV = "stg" ]
then
  (../ots-stg-redirect/deploy.sh "https://$GCLOUD_TARGET_HOST")
  gcloud app deploy "app-generated.yaml" --verbosity=info --project=$GCLOUD_PROJECT -v $GCLOUD_VERSION --no-promote --quiet
else
  echo "arghhh"
  exit 1
fi

rm -f git-sha app-generated.yaml
