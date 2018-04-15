#!/usr/bin/env bash

notice "Running database migrations and seeds"

$RELEASE_ROOT_DIR/bin/volunteer command Elixir.Volunteer.ReleaseTasks.Database run

success "All done!"
