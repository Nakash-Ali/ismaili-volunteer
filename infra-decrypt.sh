#!/usr/bin/env bash

set -e

gpg --yes --batch --passphrase=$INFRA_GPG_PASS --output ./infra/config.stg.appengine-secrets.exs --decrypt ./infra/config.stg.appengine.gpg
gpg --yes --batch --passphrase=$INFRA_GPG_PASS --output ./infra/config.prod.appengine-secrets.exs --decrypt ./infra/config.prod.appengine.gpg
