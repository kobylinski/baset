#!/usr/bin/env bats

setup() {
  DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
  source $DIR/../../../src/lib/tool/string.sh
}

@test "Test tool_string_len function" {
  run tool_string_len "line 1"
  [ $output -eq 6 ]
  [ $status -eq 0 ]
}

@test "Test tool_string_len function with fornatting" {
  run tool_string_len "line \033[38;5;250;48;5;215mwith formatting"
  [ $output -eq 20 ]
}

@test "Test tool_string_len longest string result" {
  run tool_string_len "short", "medium", "22 letters long string"
  [ $output -eq 22 ]
}

@test "Test tool_string_len function no args" {
  run tool_string_len
  [ $status -eq 1 ]
}