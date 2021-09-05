#!/usr/bin/env bats

function setup() {
  DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
  source "$DIR/../src/colors.sh"
  source "$DIR/../src/die.sh"
  source "$DIR/../src/output/strings.sh"
  source "$DIR/../src/output/error.sh"
  source "$DIR/../src/output/warning.sh"
  source "$DIR/../src/output/success.sh"
  source "$DIR/../src/output/list.sh"
}

@test "Test strlen function" {
  run strlen "line 1"
  [ $output -eq 6 ]
}

@test "Test strlen function with fornatting" {
  run strlen "line \033[38;5;250;48;5;215mwith formatting"
  [ $output -eq 20 ]
}

@test "Test strlen longest string result" {
  run strlen "short", "medium", "22 letters long string"
  [ $output -eq 22 ]
}

@test "Test error: has error label" {
  run error "Title" 
  [[ "${lines[0]}" =~ "ERROR" ]]
}

@test "Test error: has title" {
  run error "Title"
  [[ "${lines[0]}" =~ "Title" ]]
}

@test "Test error: has extra line" {
  run error "Title" "Some extra message"
  [[ "${lines[1]}" =~ "Some extra message" ]]
}

@test "Test die" {
  run die "Some message"
  [ $status -eq 1 ]
  [[ "${lines[0]}" =~ "ERROR"  ]] 
}

@test "Test warning: has warning label" {
  run warning "Title" 
  [[ "${lines[0]}" =~ "WARNING" ]]
}

@test "Test warning: has title" {
  run warning "Title"
  [[ "${lines[0]}" =~ "Title" ]]
}

@test "Test warning: has extra line" {
  run warning "Title" "Some extra message"
  [[ "${lines[1]}" =~ "Some extra message" ]]
}

@test "Test success: has success label" {
  run success "Title" 
  [[ "${lines[0]}" =~ "SUCCESS" ]]
}

@test "Test success: has title" {
  run success "Title"
  [[ "${lines[0]}" =~ "Title" ]]
}

@test "Test success: has extra line" {
  run success "Title" "Some extra message"
  [[ "${lines[1]}" =~ "Some extra message" ]]
}

@test "Test numerable list: numbers" {
  run list# "First point" "Second point" "Third point"
  [[ "${lines[1]}" =~ "2." ]] 
}

@test "Test numerable list: values" {
  run list# "First point" "Second point" "Third point"
  [[ "${lines[2]}" =~ "Third point" ]] 
}

@test "Test bullet list: values" {
  run list* "First point" "Second point" "Third point"
  [[ "${lines[2]}" =~ "Third point" ]] 
}