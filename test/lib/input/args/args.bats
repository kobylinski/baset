#!/usr/bin/env bats

function setup() {
  DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
  source "$DIR/../../../../src/lib/input/args.sh"
}

@test "test initial state" {
  [ -z "$INPUT_ARG_S" ]
  [ -z "$INPUT_ARG_S_D" ]
}

@test "test new argument" {
  input_args "argument_name" "Argument description"
  [[ "$INPUT_ARG_S" == "argument_name" ]]
  [[ "$INPUT_ARG_S_D" == "Argument description" ]]
}

@test "test missing func arguments" {
  run input_arg
  [[ $status -eq 1 ]]
}