#!/usr/bin/env bats

setup() {
  DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
  source $DIR/../../src/tool/array.sh
}

@test "Test tool_array_last function" {
  TEST_ARRAY=("a" "b" "c" "d" "e")
  run tool_array_last TEST_ARRAY
  [[ ${lines[0]} == "e" ]]
  [[ $status -eq 0 ]]
}

@test "Test tool_array_last function fails on empty array" {
  TEST_ARRAY=()
  run tool_array_last TEST_ARRAY
  [[ $status -eq 3 ]]
}

@test "Test tool_array_last function fails on no args" {
  run tool_array_last
  [[ $status -eq 1 ]]
}

@test "Test took_array_last function fails on no array" {
  run tool_array_last UNDEFINED_VARIABLE
  [[ $status -eq 2 ]]
}

@test "Test tool_array_push function" {
  TEST_ARRAY=("a" "b" "c" "d" "e")
  tool_array_push TEST_ARRAY "f" 
  [[ ${#TEST_ARRAY[@]} -eq 6 ]]
  [[ ${TEST_ARRAY[5]} == "f" ]] 
  tool_array_push TEST_ARRAY "g" 
  [[ ${#TEST_ARRAY[@]} -eq 7 ]]
  [[ ${TEST_ARRAY[5]} == "f" ]]
  [[ ${TEST_ARRAY[6]} == "g" ]]
}

@test "Test tool_array_push function succeed" {
  TEST_ARRAY=()
  run tool_array_push TEST_ARRAY "a"
  [[ $status -eq 0 ]]
}

@test "Test tool_array_push function fails on no args" {
  run tool_array_push
  [[ $status -eq 1 ]]
}

@test "Test tool_array_push function fails on invaild array" {
  run tool_array_push UNDEFINED_VARIABLE "a"
  [[ $status -eq 2 ]]
}

@test "Test tool_array_pop function" {
  TEST_ARRAY=("a" "b" "c" "d" "e")
  tool_array_pop TEST_ARRAY
  [[ $TOOL_ARRAY_LAST_ITEM == "e" ]]
  [[ -z ${TEST_ARRAY[5]} ]] 
  [[ ${#TEST_ARRAY[@]} -eq 4 ]]
  tool_array_pop TEST_ARRAY
  [[ $TOOL_ARRAY_LAST_ITEM == "d" ]]
  [[ -z ${TEST_ARRAY[4]} ]] 
  [[ ${#TEST_ARRAY[@]} -eq 3 ]]
}

@test "Test tool_array_pop fails on empty array" {
  TEST_ARRAY=()
  run tool_array_pop TEST_ARRAY
  [[ $status -eq 3 ]]
}

@test "Test tool_array_pop function succeed" {
  TEST_ARRAY=("a")
  run tool_array_pop TEST_ARRAY
  [[ $status -eq 0 ]]
}

@test "Test tool_array_pop function fails on no args" {
  run tool_array_pop
  [[ $status -eq 1 ]]
}

@test "Test tool_array_pop function fails on invaild array" {
  run tool_array_pop UNDEFINED_VARIABLE
  [[ $status -eq 2 ]]
}

@test "Test tool_array_unshift function" {
  TEST_ARRAY=("a" "b" "c" "d" "e")
  tool_array_unshift TEST_ARRAY "9"
  [[ ${#TEST_ARRAY[@]} -eq 6 ]]
  [[ ${TEST_ARRAY[5]} == "e" ]] 
  [[ ${TEST_ARRAY[0]} == "9" ]] 
  tool_array_unshift TEST_ARRAY "8"
  [[ ${#TEST_ARRAY[@]} -eq 7 ]]
  [[ ${TEST_ARRAY[5]} == "d" ]] 
  [[ ${TEST_ARRAY[0]} == "8" ]] 
}

@test "Test tool_array_unshift function succeed" {
  TEST_ARRAY=()
  run tool_array_unshift TEST_ARRAY "a"
  [[ $status -eq 0 ]]
}

@test "Test tool_array_unshift function fails on no args" {
  run tool_array_unshift
  [[ $status -eq 1 ]]
}

@test "Test tool_array_unshift function fails on invaild array" {
  run tool_array_unshift UNDEFINED_VARIABLE "a"
  [[ $status -eq 2 ]]
}

@test "Test tool_array_shift" {
  TEST_ARRAY=("a" "b" "c" "d" "e")
  tool_array_shift TEST_ARRAY
  [[ $TOOL_ARRAY_LAST_ITEM == "a" ]]
  [[ ${TEST_ARRAY[0]} == "b" ]] 
  [[ ${#TEST_ARRAY[@]} -eq 4 ]]
  tool_array_shift TEST_ARRAY
  [[ $TOOL_ARRAY_LAST_ITEM == "b" ]]
  [[ ${#TEST_ARRAY[@]} -eq 3 ]]
}

@test "Test tool_array_shift fails on empty array" {
  TEST_ARRAY=()
  run tool_array_shift TEST_ARRAY
  [[ $status -eq 3 ]]
}

@test "Test tool_array_shift function succeed" {
  TEST_ARRAY=("a")
  run tool_array_shift TEST_ARRAY
  [[ $status -eq 0 ]]
}

@test "Test tool_array_shift function fails on no args" {
  run tool_array_shift
  [[ $status -eq 1 ]]
}

@test "Test tool_array_shift function fails on invaild array" {
  run tool_array_shift UNDEFINED_VARIABLE
  [[ $status -eq 2 ]]
}

@test "Test tool_array_is" {
  TEST_ARRAY=("a" "b" "c" "d" "e")
  run tool_array_is TEST_ARRAY
  [[ $status -eq 0 ]]
  NOT_ARRAY=0
  run tool_array_is NOT_ARRAY
  [[ $status -eq 1 ]]
  run tool_array_is NOT_DEFINED
  [[ $status -eq 1 ]]
}

@test "Test tool_array_in succeed" {
  TEST_ARRAY=("a" "b" "c" "d" "e")
  run tool_array_in TEST_ARRAY "c" 
  [[ $status -eq 0 ]]
}

@test "Test tool_array_in failed" {
  TEST_ARRAY=("a" "b" "c" "d" "e")
  run tool_array_in TEST_ARRAY "f" 
  [[ $status -eq 3 ]]
}

@test "Test tool_array_in function fails on no args" {
  run tool_array_in
  [[ $status -eq 1 ]]
}

@test "Test tool_array_in function fails on invaild array" {
  run tool_array_in UNDEFINED_VARIABLE "n"
  [[ $status -eq 2 ]]
}