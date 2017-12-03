#!/usr/bin/env bash
set -e
set -x

debsums | mail -s "debsums report" root
