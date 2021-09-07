#!/usr/bin/env bats

setup() {
  DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
  source $DIR/../../../src/colors.sh
  source $DIR/../../../src/tool/string.sh
}

@test "Test simple formatting <FS>test content</>" {
  run tool_string_format "before content <FS>text content</> after content"
  [[ "${lines[0]}" =~ "before content " ]]
  [[ "${lines[0]}" =~ "text content" ]]
  [[ "${lines[0]}" =~ " after content" ]]
  [[ $status -eq 0 ]]
}

@test "Test tool_string_format for no arguments" {
  run tool_string_format
  [[ $status -eq 1 ]]
}