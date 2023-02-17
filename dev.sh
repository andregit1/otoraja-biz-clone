#!/bin/bash
set -e

function start_development() {
  echo 'docker-sync start'
  docker-sync start

  echo 'docker-compose up'
  docker-compose -f docker-compose.yml -f docker-compose-dev.yml up -d
  if [ ! "$1" = '--with-out-init' ]; then
    echo 'initial_settup'
    sleep 5s
    docker-compose exec app /bin/bash -c ./initial_settup.sh
  fi
}

function stop_development() {
  echo 'docker-compose stop'
  docker-compose stop
  echo 'docker-sync stop'
  docker-sync stop
}

case $1 in
  'start' ) start_development "$2" ;;
  'stop' ) stop_development ;;
  * ) echo "$0 [start [--with-out-init]| stop]" ;;
esac

echo 'done!!'
