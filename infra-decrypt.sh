#!/usr/bin/env bash

set -e

gpg --yes --batch --passphrase=$INFRA_GPG_PASS --output ./infra/config.stg.secrets.exs --decrypt ./infra/config.stg.gpg
gpg --yes --batch --passphrase=$INFRA_GPG_PASS --output ./infra/config.prod.secrets.exs --decrypt ./infra/config.prod.gpg
