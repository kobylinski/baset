#!/usr/bin/env bash

BASET_OPTIONS=("--help")
BASET_OPTIONS_V=("help")
BASET_OPTIONS_T=("no")
BASET_OPTIONS_D=("Display help")
BASET_OPTIONS_M=("no")
BASET_ARGS=()
BASET_ARGS_D=()
BASET_ARG_S=""
BASET_ARG_S_D=""
BASET_INFO=()
BASET_SCRIPTNAME=$(basename $0)

+info() {
  local var
  for var in "$@"; do
    BASET_INFO+=( "$var" )
  done
}

+arg() {
  BASET_ARGS+=( "$1" )
  BASET_ARGS_D+=( "$2" )
}

+args() {
  BASET_ARG_S="$1"
  BASET_ARG_S_D="$2"
}

+opt() {
  local name hasValue isMulti
  if [ "${1:0:2}" == '--' ]; then
    if [ "${1:-1}" == "*" ]; then
      isMulti="yes"
      name="${1:2:-1}"
    else
      isMulti="no"
      name="${1:2}"
    fi
    if [ "${1:-1}" == "=" ]; then
      hasValue="yes"
      name="${1:2:-1}"
    else
      hasValue="no"
      name="${1:2}"
    fi
  elif [ "${1:0:1}" == "-" ]; then
    name="${1:1}"
    hasValue="no"
    isMulti="no"
  else
    die "Invalid option declatration." \
        "In case of value option start name with --" \
        "In case of flag option start name with -"
  fi
  BASET_OPTIONS+=( "$1" )
  BASET_OPTIONS_V+=( "${name/-/_}" )
  BASET_OPTIONS_T+=( "$hasValue" )
  BASET_OPTIONS_D+=( "$2" )
  BASET_OPTIONS_M+=( "$isMulti" )
}

baset_help() {
  local var i=0
  local vLen=$(strlen "${BASET_OPTIONS[@]} ${BASET_ARGS[@]}")
  printf "\n\033[${FP}mUsage:\033[${FN}m\n"
  printf "  $BASET_SCRIPTNAME [options]"
  for var in "${BASET_ARGS[@]}"; do
    printf " %s" "$var"
  done
  if [ "${BASET_ARG_S+x}" ]; then
    printf " ...%s[]" "$BASET_ARG_S"
  fi
  printf "\n\n"
  printf "\n\033[${FP}mOptions:\033[${FN}m\n"
  for var in "${BASET_OPTIONS[@]}"; do
    printf "  \033[${FA}m%-${vLen}s\033[${FN}m  %s\n" "$var" "${BASET_OPTIONS_D[$i]}"
    i=$(($i+1))
  done
  i=0
  printf "\n\033[${FP}mArguments:\033[${FN}m\n"
  for var in "${BASET_ARGS[@]}"; do
    printf "  \033[${FA}m%-${vLen}s\033[${FN}m  %s\n" "$var" "${BASET_ARGS_D[$i]}"
    i=$(($i+1))
  done
}

baset_args() {
  local var i=0 j=0 opt is optV="" optM
  local spread=()
  for var in "$@"; do
    if [ "${optV}" != "" ]; then
      if [ "$optM" == "yes" ]; then
        eval "$optV+=(\"$var\")"
      else
        eval "$optV=\"$var\""
      fi
      optV=""
      optM=""
    elif [ "${var:0:1}" = "-" ]; then
      j=0
      for opt in "${BASET_OPTIONS[@]}"; do
        if [ "$var" = "$opt" ]; then
          if [ "${BASET_OPTIONS_T[$j]}" == "yes" ]; then
            optV="${BASET_OPTIONS_V[$j]}"
            optM="${BASET_OPTIONS_M[$j]}"
            if [ "$optM" = "yes" ]; then
              is=$(eval "echo \"\${#$optV[@]}\"")
              readVto=$optV
              if [ $is -eq 0 ]; then
                eval "${BASET_OPTIONS_V[$j}=()"
              fi
            fi
          else 
            eval "${BASET_OPTIONS_V[$j]}=\"yes\""
          fi
        fi
        j=$(($j+1))
      done
    else
      if [ "${BASET_ARGS[$i]+exists}" = "exists" ]; then
        eval "${BASET_ARGS[$i]}=\"$var\""
      else
        spread+=("$var")
      fi 
      i=$(($i+1))
    fi
  done 
  if [[ ! -z "$BASET_ARG_S" ]]; then 
    eval "$BASET_ARG_S=()"
    for var in "${spread[@]}"; do
      eval "$BASET_ARG_S+=(\"$var\")"
    done
  fi
  i=0
  for var in "${BASET_OPTIONS_V[@]}"; do
    if [ ${BASET_OPTIONS_T[$i]} == "no" ]; then
      is=$(eval "echo \${$var}")
      if [ "$is" != "yes"  ]; then
        eval "$var='no'"
      fi
    fi
    i=$(($i+1))
  done
}