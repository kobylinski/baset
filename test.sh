#!/usr/bin/env bash

ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
docker run --tty --interactive --rm --volume "$ROOT:/code"  bats/bats:latest test