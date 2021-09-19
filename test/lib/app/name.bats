#!/usr/bin/env bats

function setup() {
  DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
  source "$DIR/../../../src/lib/app/name.sh"
}

@test "test initial state of app_name" {
  [[ -z "$APP_NAME" ]]
  [[ -z "$APP_V" ]]
}

@test "test app_name defines constants" {
  app_name "Application name" "0.0.1"
  [[ ! -z "$APP_NAME" ]]
  [[ ! -z "$APP_V" ]]
  [[ "$APP_NAME" == "Application name" ]]
  [[ "$APP_V" == "0.0.1" ]]
}

@test "test app_name invalid arguments" {
  run app_name
  [[ $status == 1 ]]
}

@test "test app_name already defined" {
  app_name "Application name" "0.0.1"
  run app_name "Application name" "0.0.1"
  [[ $status == 2 ]]
}

@test "test initial state of app_info" {
  [[ -z "$APP_INFO" ]]
}

@test "test app_info defines constant" {
  app_info "First line" "Second line"
  [[ ! -z "$APP_INFO" ]]
  [[ "${#APP_INFO[@]}" == 2 ]]
  [[ "${APP_INFO[0]}" == "First line" ]]
  [[ "${APP_INFO[1]}" == "Second line" ]]
}

@test "test app_info no args" {
  run app_info
  [[ $status == 1 ]]
}

@test "test app_info already defined" {
  app_info "First line"
  run app_info "Second line"
  [[ $status == 2 ]]
}