#!/bin/bash
set -e

rails assets:precompile

if [ -e /app/tmp/pids/*.pid ]; then rm /app/tmp/pids/*.pid; fi

exec "$@"
