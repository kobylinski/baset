#!/usr/bin/env bats

function setup() {
  DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
  source "$DIR/../../../../src/lib/input/args.sh"
}

@test "test initial state" {
  [[ "${#INPUT_ARGS[@]}" == 0 ]]
  [[ "${#INPUT_ARGS_D[@]}" == 0 ]]
}

@test "test new argument" {
  input_arg "argument_name" "Argument description"
  [[ "${#INPUT_ARGS[@]}" == 1 ]]
  [[ "${INPUT_ARGS[0]}" == "argument_name" ]]
  [[ "${INPUT_ARGS_D[0]}" == "Argument description" ]]
}

@test "test missing func arguments" {
  run input_arg
  [[ $status -eq 1 ]]
}