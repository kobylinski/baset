#!/usr/bin/env bats

setup() {
  DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
  source $DIR/../../../../src/colors.sh
  source $DIR/../../../../src/lib/tool/string.sh
}

@test "Test simple formatting <ERROR>test content</>" {
  run tool_string_format "before content <ERROR>text content</> after content"
  EXPECTED=$(printf "before content \033[38;5;232;48;5;196mtext content\033[0m after content")
  [[ "${lines[0]}" == "${EXPECTED}" ]]
  [[ $status -eq 0 ]]
}

@test "Test tool_string_format for no arguments" {
  run tool_string_format
  [[ $status -eq 1 ]]
}

@test "Test no color output" {
  no_color="yes" 
  run tool_string_format "before content <ERROR>text content</> after content"
  EXPECTED=$(printf "before content text content after content")
  [[ "${lines[0]}" == "${EXPECTED}" ]]
  [[ $status -eq 0 ]]
}