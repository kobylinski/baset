#!/usr/bin/env bats

function setup() {
  DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
  source "$DIR/../../../src/colors.sh"
  source "$DIR/../../../src/lib/tool/string.sh"
  source "$DIR/../../../src/lib/output/list.sh"
}

@test "Test numerable list: numbers" {
  run output_ordered_list "First point" "Second point" "Third point"
  [[ "${lines[1]}" =~ "2." ]] 
}

@test "Test numerable list: values" {
  run output_ordered_list "First point" "Second point" "Third point"
  [[ "${lines[2]}" =~ "Third point" ]] 
}