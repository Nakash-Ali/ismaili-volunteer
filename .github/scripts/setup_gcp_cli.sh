#!/usr/bin/env bash

set -e

source <(elixir ./infra/generate-envvars.exs --env prod)
gcloud auth activate-service-account --key-file ./infra/gcp.serviceaccount.deploy.secrets.json
gcloud config set project $GCLOUD_PROJECT
gcloud config set app/cloud_build_timeout 60m
