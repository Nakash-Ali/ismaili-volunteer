#!/usr/bin/env bash

set -e

gpg --yes --batch --passphrase=$INFRA_GPG_PASS --output ./infra/config.stg.gpg --symmetric ./infra/config.stg.secrets.exs
gpg --yes --batch --passphrase=$INFRA_GPG_PASS --output ./infra/config.prod.gpg --symmetric ./infra/config.prod.secrets.exs
