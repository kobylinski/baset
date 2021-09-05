#!/usr/bin/env bash

baset() {
  printf "\033[${FA}m%s\033[${FN}m" "$1"
  if [ "${2+x}" ]; then 
    printf " version \033[${FP}m%s\33[${FN}m" "$2"
  fi
  printf "\n"
}
