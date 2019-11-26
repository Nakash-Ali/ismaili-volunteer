#!/usr/bin/env bash

set -e

GCLOUD_ENV=$1;

case $GCLOUD_ENV in
  prod|stg) ;;
    *) echo "invalid environment" && exit 1;;
esac

source <(elixir ./infra/generate-envvars.exs --env $GCLOUD_ENV)

set -x

rm -f git-sha app-generated.yaml

if [ $GCLOUD_ENV = "prod" ]; then
  test -z "$(git status --porcelain)"
fi

echo $GIT_SHA >> git-sha

elixir infra/generate-appengine.exs --env $GCLOUD_ENV --out "./app-generated.yaml"

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
