#!/usr/bin/env bash

set -e

gpg --yes --batch --passphrase=$INFRA_GPG_PASS --output ./infra/gcp.serviceaccount.deploy.secrets.json --decrypt ./infra/gpg.gcp.serviceaccount.deploy.bin

gpg --yes --batch --passphrase=$INFRA_GPG_PASS --output ./infra/config.stg.secrets.exs --decrypt ./infra/gpg.config.stg.bin
gpg --yes --batch --passphrase=$INFRA_GPG_PASS --output ./infra/config.prod.secrets.exs --decrypt ./infra/gpg.config.prod.bin
