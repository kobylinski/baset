#!/usr/bin/env bats

function setup() {
  DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
  source "$DIR/../../../../src/lib/input/args.sh"
}

@test "Test predefined options" {
  [[ "${#INPUT_OPTIONS[@]}" == 3 ]]
  [[ "${#INPUT_OPTIONS_V[@]}" == 3 ]]
  [[ "${#INPUT_OPTIONS_T[@]}" == 3 ]]
  [[ "${#INPUT_OPTIONS_D[@]}" == 3 ]]
  [[ "${#INPUT_OPTIONS_M[@]}" == 3 ]]
}

@test "Test flag option" {
  input_opt "--test-option" "Test option"
  [[ "${#INPUT_OPTIONS[@]}" == "4" ]]
  [[ "${INPUT_OPTIONS[3]}" == "--test-option" ]]
  [[ "${INPUT_OPTIONS_V[3]}" == "test_option" ]]
  [[ "${INPUT_OPTIONS_T[3]}" == "no" ]]
  [[ "${INPUT_OPTIONS_D[3]}" == "Test option" ]]
  [[ "${INPUT_OPTIONS_M[3]}" == "no" ]]
}

@test "Test value option" {
  input_opt "--test-option=" "Test option"
  [[ "${INPUT_OPTIONS_T[3]}" == "yes" ]]
}

@test "Test multi option" {
  input_opt "--test-option*" "Test option"
  [[ "${INPUT_OPTIONS_M[3]}" == "yes" ]]
}

@test "Success return" {
  run input_opt "--test-option" "Test option"
  [[ $status == 0 ]]
}

@test "Missing arguments" {
  run input_opt 
  [[ $status == 1 ]]
}

@test "Invalid signature" {
  run input_opt "test-option" "Test option"
  [[ $status == 2 ]]
}