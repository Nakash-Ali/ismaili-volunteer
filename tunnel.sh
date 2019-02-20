#!/usr/bin/env bash

set -ex

ngrok http 4000 -subdomain=ots-local
