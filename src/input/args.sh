#!/usr/bin/env bash

# Script option storage
# Options storage
BASET_OPTIONS=("--help" "-v")                            # option signature
BASET_OPTIONS_V=("help" "verbose")                       # variable name represents option
BASET_OPTIONS_T=("no" "no")                              # if option is a flag type or value type
BASET_OPTIONS_D=("Display help" "Show debug comments")   # option help description
BASET_OPTIONS_M=("no" "no")                              # if option can contains multiple values
# In variable namespace will be also createding additional set
# of variables with command prefix for command specific options

# Arguments storage
BASET_ARGS=()     # List of arguments
BASET_ARGS_D=()   # List of descriptions of arguments for help view
# Also available with command prefix

# Spread argumets storage
# Represents one argument containse all other undefined arguments appears in command line
BASET_ARG_S=""    # Argument name
BASET_ARG_S_D=""  # Argument help message
# Also available with command prefix

# General information about tool
# It can contains multiline string
BASET_INFO=()
# It has also command specific version as variable with prefix

# Current script name
BASET_SCRIPTNAME=$(basename $0)

# List of available commands
BASET_COMMANDS=()
BASET_COMMANDS_D=()
BASET_COMMANDS_CURRENT=""
#====================================================================================================

# Add multiline information about tool or currently active command
# - $... List of following lines of information
+info() {
  local var
  for var in "$@"; do
    if [ -z "$BASET_COMMANDS_CURRENT" ]; then
      BASET_INFO+=( "$var" )
    else
      eval "${BASET_COMMANDS_CURRENT}_BASET_INFO+=( \"$var\" )"
    fi
  done
}

# Add tool/command named argument
# Value of this argument will be pass into bash variable with the same name
# - $1 argument name
# - $2 argument help description
+arg() {
  if [ -z "$BASET_COMMANDS_CURRENT" ]; then
    BASET_ARGS+=( "$1" )
    BASET_ARGS_D+=( "$2" )
  else
    eval "${BASET_COMMANDS_CURRENT}_BASET_ARGS+=( \"$1\" )"
    eval "${BASET_COMMANDS_CURRENT}_BASET_ARGS_D+=( \"$2\" )"
  fi
}

# Add special spread argument at the end of arguments contains all unspecified arguments passed to tool/command
# - $1 argument name
# - $2 argument help description
+args() {
  if [ -z "$BASET_COMMANDS_CURRENT" ]; then
    BASET_ARG_S="$1"
    BASET_ARG_S_D="$2"
  else
    eval "${BASET_COMMANDS_CURRENT}_BASET_ARG_S=( \"$1\" )"
    eval "${BASET_COMMANDS_CURRENT}_BASET_ARG_S_D=( \"$2\" )"
  fi
}

# Add option with format: 
# --option-name or -name for flag option with value yes or no
# --option-name= for value option
# --option-name* form multi-value option
#
# - $1 option name
# - $2 option description
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

  if [ -z "$BASET_COMMANDS_CURRENT" ]; then
    BASET_OPTIONS+=( "$1" )
    BASET_OPTIONS_V+=( "${name/-/_}" )
    BASET_OPTIONS_T+=( "$hasValue" )
    BASET_OPTIONS_D+=( "$2" )
    BASET_OPTIONS_M+=( "$isMulti" )
  else
    eval "${BASET_COMMANDS_CURRENT}_BASET_OPTIONS+=( \"$1\" )"
    eval "${BASET_COMMANDS_CURRENT}_BASET_OPTIONS_V+=( \"${name/-/_}\" )"
    eval "${BASET_COMMANDS_CURRENT}_BASET_OPTIONS_T+=( \"$hasValue\" )"
    eval "${BASET_COMMANDS_CURRENT}_BASET_OPTIONS_D+=( \"$2\" )"
    eval "${BASET_COMMANDS_CURRENT}_BASET_OPTIONS_M+=( \"$isMulti\" )"
  fi
}

# Add new command
# - $1 Command name
# - $2 Command description
+cmd() {
  BASET_COMMANDS+=( "$1" )
  BASET_COMMANDS_D+=( "$2" )
  BASET_COMMANDS_CURRENT="$1"
  eval "${1}_BASET_OPTIONS=()"
  eval "${1}_BASET_OPTIONS_V=()"
  eval "${1}_BASET_OPTIONS_T=()"
  eval "${1}_BASET_OPTIONS_D=()"
  eval "${1}_BASET_OPTIONS_M=()"
  eval "${1}_BASET_ARGS=()"
  eval "${1}_BASET_ARGS_D=()"
  eval "${1}_BASET_ARG_S=\"\""
  eval "${1}_BASET_ARG_S_D=\"\""
  eval "${1}_BASET_INFO=()"
}

# Print args help
baset_help() {
  local var i=0 is
  local options=("${BASET_OPTIONS[@]}")
  local options_d=("${BASET_OPTIONS_D[@]}")
  local args=("${BASET_ARGS[@]}")
  local args_d=("${BASET_ARGS_D[@]}")
  local arg_s="$BASET_ARG_S"
  local vlen
  local hLen=$(strlen "${BASET_INFO[@]}")

  # Print tool header
  if [ ${#BASET_INFO[@]} -ne 0 ]; then
    for var in "${BASET_INFO[@]}"; do
      printf "\n\033[${FAF}m %s\033[${FN}m" "$var"
    done
    printf "\n \033[${FA}m%${hLen}s\033[${FN}m" "Version $BASET_APP_V"
  else
    baset_head
  fi

  if [ ! -z "${BASET_COMMANDS_CURRENT}" ]; then
    i=0
    for var in "${BASET_COMMANDS[@]}"; do
      if [[ "$var" == "$BASET_COMMANDS_CURRENT" ]]; then
        printf "\n\n\033[${FAF}m  %s\033[${FN}m" "${BASET_COMMANDS_D[$i]}"
      fi
      i=$(($i+1))
    done
  fi

  # Usage header
  printf "\n\n\033[${FP}mUsage:\033[${FN}m\n\n"
  printf "  \033[${FAF}m$BASET_SCRIPTNAME\033[${FN}m [options]"

  # Merge options and arbuments command specific
  if [ ! -z "${BASET_COMMANDS_CURRENT}" ]; then
    eval "options=(\"\${options[@]}\" \"\${${BASET_COMMANDS_CURRENT}_BASET_OPTIONS[@]}\")"  
    eval "options_d=(\"\${options_d[@]}\" \"\${${BASET_COMMANDS_CURRENT}_BASET_OPTIONS_D[@]}\")"  
    eval "args=(\"\${args[@]}\" \"\${${BASET_COMMANDS_CURRENT}_BASET_ARGS[@]}\")"
    eval "args_d=(\"\${args_d[@]}\" \"\${${BASET_COMMANDS_CURRENT}_BASET_ARGS_D[@]}\")"

    # Maximum lenght of attribute names to nice printing
    vLen=$(strlen "${options[@]} ${args[@]}")

    # Check if command specific spread attribute is defined
    is=$(eval "echo \${${BASET_COMMANDS_CURRENT}_BASET_ARG_S}")

    # Override default spread attribute
    if [ ! -z "${is}" ]; then
      arg_s="$is"
    fi

    printf " \033[${FAF}m%s\033[${FN}m" "$BASET_COMMANDS_CURRENT"

    # Display usage of command
  else
    vLen=$(strlen "${options[@]} ${args[@]} ${BASET_COMMANDS[@]}")

    # Display global usage
    if [ "${#BASET_COMMANDS[@]}" -ne 0 ]; then
      # when commands are defined
      printf " {command}"
    fi
  fi

  # Display rest of args
  for var in "${args[@]}"; do
    printf " {%s}" "$var"
  done

  # Display last spread argument
  if [ ! -z "${arg_s}" ]; then
    printf " {%s[]}" "$arg_s"
  fi

  # Display available optioms
  i=0
  printf "\n\n\n\033[${FP}mOptions:\033[${FN}m\n"
  for var in "${options[@]}"; do
    printf "  \033[${FA}m%-${vLen}s\033[${FN}m  %s\n" "$var" "${options_d[$i]}"
    i=$(($i+1))
  done

  # Display available arguments
  i=0
  printf "\n\033[${FP}mArguments:\033[${FN}m\n"
  for var in "${args[@]}"; do
    printf "  \033[${FA}m%-${vLen}s\033[${FN}m  %s\n" "$var" "${args_d[$i]}"
    i=$(($i+1))
  done

  # Display available commands only if none is active
  if [ -z "${BASET_COMMANDS_CURRENT}" ]; then
    i=0
    printf "\n\033[${FP}mCommands:\033[${FN}m\n"
    for var in "${BASET_COMMANDS[@]}"; do
      printf "  \033[${FA}m%-${vLen}s\033[${FN}m  %s\n" "$var" "${BASET_COMMANDS_D[$i]}"
      i=$(($i+1))
    done
  fi
  exit 0
}

# Parse current args
# - $... List of command line arguments to parse
baset_args() {
  BASET_COMMANDS_CURRENT=""
  local var i=0 j=0 opt is optV="" optM
  local mergedOpts=("${BASET_OPTIONS[@]}") 
  local mergedOpts_t=("${BASET_OPTIONS_T[@]}") 
  local mergedOpts_v=("${BASET_OPTIONS_V[@]}")
  local mergedOpts_m=("${BASET_OPTIONS_M[@]}")
  local mergedArgs=("${BASET_ARGS[@]}")
  local mergedArg_s=""
  local spread=()
  for var in "$@"; do
    
    # In case of assign value to option
    if [ "${optV}" != "" ]; then
      if [ "$optM" == "yes" ]; then
        # If option is multivalue
        eval "$optV+=(\"$var\")"
      else
        # If option is single value
        eval "$optV=\"$var\""
      fi

      # Reset watch variables
      optV="" # Option variable name
      optM="" # Is option is multivalue

    # In case when argument begins with -
    # mean its option
    elif [ "${var:0:1}" = "-" ]; then
      j=0      
      # Iterate through defined options
      for opt in "${mergedOpts[@]}"; do
        if [ "$var" == "$opt" ]; then
          if [ "${mergedOpts_t[$j]}" == "yes" ]; then
            optV="${mergedOpts_v[$j]}"
            optM="${mergedOpts_m[$j]}"
            if [ "$optM" = "yes" ]; then
              is=$(eval "echo \"\${#$optV[@]}\"")
              readVto=$optV
              if [ $is -eq 0 ]; then
                eval "${mergedOpts_v[$j}=()"
              fi
            fi
          else 
            eval "${mergedOpts_v[$j]}=\"yes\""
          fi
        fi
        j=$(($j+1))
      done
    else

      # If there is no command set and its first argument detected
      if [ -z "$BASET_COMMANDS_CURRENT" -a $i -eq 0 ]; then

        # Iterate through defined commands looking for match
        for j in "${BASET_COMMANDS[@]}"; do
          if [ "$j" == "$var" ]; then

            # Set current active command
            BASET_COMMANDS_CURRENT="$var"

            # Update list of available options with command specific 
            eval "mergedOpts=(\"\${BASET_OPTIONS[@]}\" \"\${${BASET_COMMANDS_CURRENT}_BASET_OPTIONS[@]}\")"
            eval "mergedOpts_t=(\"\${BASET_OPTIONS_T[@]}\" \"\${${BASET_COMMANDS_CURRENT}_BASET_OPTIONS_T[@]}\")"
            eval "mergedOpts_v=(\"\${BASET_OPTIONS_V[@]}\" \"\${${BASET_COMMANDS_CURRENT}_BASET_OPTIONS_V[@]}\")"
            eval "mergedOpts_m=(\"\${BASET_OPTIONS_M[@]}\" \"\${${BASET_COMMANDS_CURRENT}_BASET_OPTIONS_M[@]}\")"

            # Update args with command specific ones
            eval "mergedArgs=(\"\${BASET_ARGS[@]}\" \"\${${BASET_COMMANDS_CURRENT}_BASET_ARGS[@]}\")"
          fi
        done
      else
        if [ "${mergedArgs[$i]+x}" ]; then
          eval "${mergedArgs[$i]}=\"$var\""
        else
          spread+=("$var")
        fi   
      fi
      i=$(($i+1))
    fi
  done 
  if [ -z "$BASET_COMMANDS_CURRENT" ]; then
    mergedArg_s="$BASET_ARG_S" 
  else
    eval "mergedArg_s=\${${BASET_COMMANDS_CURRENT}_BASET_ARG_S}"
  fi
  if [[ ! -z "$mergedArg_s" ]]; then
    eval "$mergedArg_s=()"
    for var in "${spread[@]}"; do
      eval "$mergedArg_s+=(\"$var\")"
    done
  fi
  i=0
  for var in "${mergedOpts_v[@]}"; do
    if [ ${mergedOpts_t[$i]} == "no" ]; then
      is=$(eval "echo \${$var}")
      if [ "$is" != "yes"  ]; then
        eval "$var='no'"
      fi
    fi
    i=$(($i+1))
  done
}