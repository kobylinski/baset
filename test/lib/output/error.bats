#!/usr/bin/env bats

function setup() {
  DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
  source "$DIR/../../../src/colors.sh"
  source "$DIR/../../../src/lib/tool/string.sh"
  source "$DIR/../../../src/lib/output/message.sh"
}

@test "Test error: has error label" {
  run output_error "Title" 
  [[ "${lines[0]}" =~ "ERROR" ]]
}

@test "Test error: has title" {
  run output_error "Title"
  [[ "${lines[0]}" =~ "Title" ]]
}

@test "Test error: has extra line" {
  run output_error "Title" "Some extra message"
  [[ "${lines[1]}" =~ "Some extra message" ]]
}