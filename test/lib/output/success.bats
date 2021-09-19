#!/usr/bin/env bats

function setup() {
  DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
  source "$DIR/../../../src/colors.sh"
  source "$DIR/../../../src/lib/tool/string.sh"
  source "$DIR/../../../src/lib/output/message.sh"
}

@test "Test success: has success label" {
  run output_success "Title" 
  [[ "${lines[0]}" =~ "SUCCESS" ]]
}

@test "Test success: has title" {
  run output_success "Title"
  [[ "${lines[0]}" =~ "Title" ]]
}

@test "Test success: has extra line" {
  run output_success "Title" "Some extra message"
  [[ "${lines[1]}" =~ "Some extra message" ]]
}