#!/usr/bin/env bats

function setup() {
  DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
  source "$DIR/../../../src/lib/colors.sh"
  source "$DIR/../../../src/output/strings.sh"
  source "$DIR/../../../src/output/error.sh"
}

  # source "$DIR/../../../src/output/warning.sh"
  # source "$DIR/../../../src/output/success.sh"
  # source "$DIR/../../../src/output/list.sh"

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