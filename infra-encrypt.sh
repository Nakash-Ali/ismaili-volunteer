#!/usr/bin/env bash

set -e

gpg --yes --batch --passphrase=$INFRA_GPG_PASS --output ./infra/config.stg.appengine.gpg --symmetric ./infra/config.stg.appengine-secrets.exs
gpg --yes --batch --passphrase=$INFRA_GPG_PASS --output ./infra/config.prod.appengine.gpg --symmetric ./infra/config.prod.appengine-secrets.exs
