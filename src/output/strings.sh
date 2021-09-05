#!/usr/bin/env bash

strlen(){
  local size=0 line realLine realLineSise
  for line in "$@"; do
    realLine=$(echo $line | sed 's/\\033\[[0-9;]*m//g')
    realLineSise=${#realLine}
    if [ $size -lt $realLineSise ]; then
      size=$realLineSise
    fi
  done
  echo $size;
}