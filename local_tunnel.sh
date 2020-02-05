#!/usr/bin/env bash

set -xeuf -o pipefail

ngrok http 4000 -subdomain=ots-local
