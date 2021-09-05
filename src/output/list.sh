#!/usr/bin/env bash

list#() {
  local count=$#
  local cc=${#count} line i=1
  for line in "$@"; do
    printf -- "  \033[${FPF};${FI}m%${cc}s.\033[${FN}m \033[${FP}m%s\033[${FN}m\n" "$i" "$line"
    i=$(($i + 1))
  done
}

list*() {
  for line in "$@"; do
    printf -- "  \033[${FPF};${FI}m%s\033[${FN}m \033[${FP}m%s\033[${FN}m\n" $'\xE2\x80\xa2' "$line"
  done
}