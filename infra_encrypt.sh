#!/usr/bin/env bash

set -euf -o pipefail

gpg --yes --batch --passphrase="$INFRA_GPG_PASS" --output ./infra/gpg.gcp.serviceaccount.deploy.bin --symmetric ./infra/gcp.serviceaccount.deploy.secrets.json

gpg --yes --batch --passphrase="$INFRA_GPG_PASS" --output ./infra/gpg.config.stg.bin --symmetric ./infra/config.stg.secrets.exs
gpg --yes --batch --passphrase="$INFRA_GPG_PASS" --output ./infra/gpg.config.prod.bin --symmetric ./infra/config.prod.secrets.exs
