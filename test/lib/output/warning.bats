#!/usr/bin/env bats

function setup() {
  DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
  source "$DIR/../../../src/colors.sh"
  source "$DIR/../../../src/lib/tool/string.sh"
  source "$DIR/../../../src/lib/output/message.sh"
}

@test "Test warning: has warning label" {
  run output_warning "Title" 
  [[ "${lines[0]}" =~ "WARNING" ]]
}

@test "Test warning: has title" {
  run output_warning "Title"
  [[ "${lines[0]}" =~ "Title" ]]
}

@test "Test warning: has extra line" {
  run output_warning "Title" "Some extra message"
  [[ "${lines[1]}" =~ "Some extra message" ]]
}