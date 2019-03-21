#!/usr/bin/env bash

notice "Running database migrations and seeds"

$RELEASE_ROOT_DIR/bin/volunteer database

success "All done!"
