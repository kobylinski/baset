#!/usr/bin/env bats

function setup() {
  DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
  source "$DIR/../../../../src/lib/input/args.sh"
}

@test "test initial state" {
  [[ "${#INPUT_COMMANDS[@]}" == 0 ]]
  [[ "${#INPUT_COMMANDS_D[@]}" == 0 ]]
  [ -z "$INPUT_COMMANDS_CURRENT" ]
}

@test "test new command" {
  input_cmd "command_name" "Command description"
  [[ "${#INPUT_COMMANDS[@]}" == 1 ]]
  [[ "${INPUT_COMMANDS[0]}" == "command_name" ]]
  [[ "${INPUT_COMMANDS_D[0]}" == "Command description" ]]
  [[ "$INPUT_COMMANDS_CURRENT" == "command_name" ]]
}

@test "test missing func arguments" {
  run input_cmd
  [[ $status -eq 1 ]]
}