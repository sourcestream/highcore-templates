#!/bin/bash

export UID
docker-compose build sparkle > /dev/null
docker-compose run --rm sparkle "$@"