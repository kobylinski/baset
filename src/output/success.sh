#!/usr/bin/env bash

success() {
  local len=$(strlen "SUCCESS: $1" "${@:2}") line
  len="$(($len + 4))"
  local titleLen="$(($len - 10))"
  printf -- "\033[${FI};${FSF}m%s\033[${FN}m" " SUCCESS: "
  printf -- "\033[${FS}m%-${titleLen}s\033[${FN}m\n" "$1"
  if [ $# -gt 1 ]; then
    local pointLen=$(($len - 3))
    for line in "${@:2}"; do
      printf -- "\033[${FI};${FSF}m%s\033[${FN}m" " * "
      printf -- "\033[${FSF}m%-${pointLen}s\033[${FN}m\n" "$line"
    done
  fi
}