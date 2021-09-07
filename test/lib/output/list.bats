#!/usr/bin/env bats

function setup() {
  DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
  source "$DIR/../../../src/lib/colors.sh"
  source "$DIR/../../../src/output/strings.sh"
  source "$DIR/../../../src/output/list.sh"
}

@test "Test numerable list: numbers" {
  run output_ordered_list "First point" "Second point" "Third point"
  [[ "${lines[1]}" =~ "2." ]] 
}

@test "Test numerable list: values" {
  run output_ordered_list "First point" "Second point" "Third point"
  [[ "${lines[2]}" =~ "Third point" ]] 
}

@test "Test bullet list: values" {
  run output_list "First point" "Second point" "Third point"
  [[ "${lines[2]}" =~ "Third point" ]] 
}