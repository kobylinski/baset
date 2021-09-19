# Parse too arguments
###############################################################################
# Script option storage - datastructure describes options
# 
# Structure:
# (
#   INPUT_OPTIONS: signature
#   INPUT_OPTIONS_V: variable name represents option
#   INPUT_OPTIONS_T: if option is a flag type or value type
#   INPUT_OPTIONS_D: option help description
#   INPUT_OPTIONS_M: if option can contains multiple values
# )
# In variable namespace will be also createding additional set of variables 
# with command prefix for command specific options
# ( 
#   cmd_prefix_INPUT_OPTIONS 
#   cmd_prefix_INPUT_OPTIONS_V  
#   cmd_prefix_INPUT_OPTIONS_T
#   cmd_prefix_INPUT_OPTIONS_D
#   cmd_prefix_INPUT_OPTIONS_M
# )
# 
# Used by:
#   input_opt
#   input_parse
#   input_cmd
#   input_print_help
###############################################################################
INPUT_OPTIONS=("--help" "-v" "--no-color")                      
INPUT_OPTIONS_V=("help" "verbose" "no_color")                
INPUT_OPTIONS_T=("no" "no" "no")                      
INPUT_OPTIONS_D=("Display help" "Show debug comments" "Disable color output") 
INPUT_OPTIONS_M=("no" "no" "no")

###############################################################################
# Arguments storage
#
# Structure:
# (
#   INPUT_ARGS: List of arguments
#   INPUT_ARGS_D: List of descriptions of arguments for help view
# )
# Also available with command prefix
# (
#   cmd_prefix_INPUT_ARGS
#   cmd_prefix_INPUT_ARGS_D
# )
#
# Used by:
#   input_arg
#   input_cmd
#   input_print_help
#   input_parse
###############################################################################
INPUT_ARGS=()   
INPUT_ARGS_D=()

###############################################################################
# Spread argumets storage
#
# Represents one argument containse all other undefined arguments appears in 
# command line
# ( 
#   INPUT_ARG_S: Argument name
#   INPUT_ARG_S_D: Argument help message
# )
# Also available with command prefix
# (
#   cmd_prefix_INPUT_ARG_S
#   cmd_prefix_INPUT_ARGS_D
# )
#
# Used by:
#   input_args
#   input_cmd
#   input_print_help
#   input_parse
###############################################################################
INPUT_ARG_S=""   
INPUT_ARG_S_D="" 

###############################################################################
# Current script name
#
# Used by:
#   input_print_help
###############################################################################
INPUT_SCRIPTNAME=$(basename $0)

###############################################################################
# List of available commands
#
# Structure:
# (
#   INPUT_COMMANDS: List of commands signature
#   INPUT_COMMANDS_D: List of commands descriptions
# )
#
# Used by:
#   input_cmd
#   input_print_help
###############################################################################
INPUT_COMMANDS=()
INPUT_COMMANDS_D=()

###############################################################################
# Currently selected command
#
# Used by:
#   input_arg
#   input_args
#   input_opt
#   input_cmd
#   input_print_help
#   input_parse
###############################################################################
INPUT_COMMANDS_CURRENT=""

###############################################################################
# Add tool/command named argument
# Globals:
#   INPUT_COMMANDS_CURRENT
#   INPUT_ARGS
#   INPUT_ARGS_D
#   cmd_prefix_INPUT_ARGS
#   cmd_prefix_INPUT_ARGS_D
# Arguments:
#   Tool/command argument name
#   Tool/command argument description
# Returns:
#   0 on success
#   1 missing required arguments
###############################################################################
input_arg() {
  [[ $# -eq 2 ]] || return 1
  if [ -z "$INPUT_COMMANDS_CURRENT" ]; then
    INPUT_ARGS+=( "$1" )
    INPUT_ARGS_D+=( "$2" )
  else
    eval "${INPUT_COMMANDS_CURRENT}_INPUT_ARGS+=( \"$1\" )"
    eval "${INPUT_COMMANDS_CURRENT}_INPUT_ARGS_D+=( \"$2\" )"
  fi
}

###############################################################################
# Add special spread argument at the end of arguments contains all 
# unspecified arguments passed to tool/command
# Globals:
#   INPUT_COMMANDS_CURRENT
#   INPUT_ARG_S
#   INPUT_ARG_S_D
#   cmd_prefix_INPUT_ARG_S
#   cmd_prefix_INPUT_ARG_S_D
# Arguments:
#   Tool/command spread argument name
#   Tool/command spread argument description
# Returns:
#   0 on success
#   1 missing required arguments
###############################################################################
input_args() {
  [[ $# -eq 2 ]] || return 1
  if [ -z "$INPUT_COMMANDS_CURRENT" ]; then
    INPUT_ARG_S="$1"
    INPUT_ARG_S_D="$2"
  else
    eval "${INPUT_COMMANDS_CURRENT}_INPUT_ARG_S=( \"$1\" )"
    eval "${INPUT_COMMANDS_CURRENT}_INPUT_ARG_S_D=( \"$2\" )"
  fi
}

###############################################################################
# Add option
#
# Available signature formats:
# --option-name or -name for flag option with value yes or no
# --option-name= for value option
# --option-name* form multi-value option
#
# Globals:
#   INPUT_COMMANDS_CURRENT
#   INPUT_OPTIONS
#   INPUT_OPTIONS_V
#   INPUT_OPTIONS_T
#   INPUT_OPTIONS_D
#   INPUT_OPTIONS_M
#   cmd_prefix_INPUT_OPTIONS
#   cmd_prefix_INPUT_OPTIONS_V
#   cmd_prefix_INPUT_OPTIONS_T
#   cmd_prefix_INPUT_OPTIONS_D
#   cmd_prefix_INPUT_OPTIONS_M
# Arguments:
#   Option name
#   Option description
# Returns:
#   0 on success
#   1 if missing arguments
#   2 if signature has invalid format
###############################################################################
input_opt() {
  [[ $# -eq 2 ]] || return 1
  local name hasValue isMulti lastChar
  if [ "${1:0:2}" == '--' ]; then
    lastChar=${1:${#1}-1}
    if [ "$lastChar" == "*" ]; then
      isMulti="yes"
      name=${1:2:${#1}-3}
    else
      isMulti="no"
      name="${1:2}"
    fi
    if [ "$lastChar" == "=" ]; then
      hasValue="yes"
      name=${1:2:${#1}-3}
    else
      hasValue="no"
      name="${1:2}"
    fi
  elif [ "${1:0:1}" == "-" ]; then
    name="${1:1}"
    hasValue="no"
    isMulti="no"
  else
    return 2
  fi

  if [ -z "$INPUT_COMMANDS_CURRENT" ]; then
    INPUT_OPTIONS+=( "$1" )
    INPUT_OPTIONS_V+=( "${name/-/_}" )
    INPUT_OPTIONS_T+=( "$hasValue" )
    INPUT_OPTIONS_D+=( "$2" )
    INPUT_OPTIONS_M+=( "$isMulti" )
  else
    eval "${INPUT_COMMANDS_CURRENT}_INPUT_OPTIONS+=( \"$1\" )"
    eval "${INPUT_COMMANDS_CURRENT}_INPUT_OPTIONS_V+=( \"${name/-/_}\" )"
    eval "${INPUT_COMMANDS_CURRENT}_INPUT_OPTIONS_T+=( \"$hasValue\" )"
    eval "${INPUT_COMMANDS_CURRENT}_INPUT_OPTIONS_D+=( \"$2\" )"
    eval "${INPUT_COMMANDS_CURRENT}_INPUT_OPTIONS_M+=( \"$isMulti\" )"
  fi
}

###############################################################################
# Add new command
# Globals:
#   INPUT_COMMANDS
#   INPUT_COMMANDS_D
#   INPUT_COMMANDS_CURRENT
#   cmd_prefix_INPUT_OPTIONS
#   cmd_prefix_INPUT_OPTIONS_V
#   cmd_prefix_INPUT_OPTIONS_T
#   cmd_prefix_INPUT_OPTIONS_D
#   cmd_prefix_INPUT_OPTIONS_M
#   cmd_prefix_INPUT_ARGS
#   cmd_prefix_INPUT_ARGS_D
#   cmd_prefix_INPUT_ARG_S
#   cmd_prefix_INPUT_ARG_S_D
# Arguments:
#   Command name
#   Command description
# Returns:
#   0 on success
#   1 if missing arguments
###############################################################################
input_cmd() {
  [[ $# -eq 2 ]] || return 1
  INPUT_COMMANDS+=( "$1" )
  INPUT_COMMANDS_D+=( "$2" )
  INPUT_COMMANDS_CURRENT="$1"
  eval "${1}_INPUT_OPTIONS=()"
  eval "${1}_INPUT_OPTIONS_V=()"
  eval "${1}_INPUT_OPTIONS_T=()"
  eval "${1}_INPUT_OPTIONS_D=()"
  eval "${1}_INPUT_OPTIONS_M=()"
  eval "${1}_INPUT_ARGS=()"
  eval "${1}_INPUT_ARGS_D=()"
  eval "${1}_INPUT_ARG_S=\"\""
  eval "${1}_INPUT_ARG_S_D=\"\""
}

###############################################################################
# Print args help
# Output:
#   Formated help 
###############################################################################
input_print_help() {
  local var i=0 is
  local options=("${INPUT_OPTIONS[@]}")
  local options_d=("${INPUT_OPTIONS_D[@]}")
  local options_v=("${INPUT_OPTIONS_V[@]}")
  local args=("${INPUT_ARGS[@]}")
  local args_d=("${INPUT_ARGS_D[@]}")
  local arg_s="$INPUT_ARG_S"
  local arg_s_d="$INPUT_ARG_S_D"
  local vlen vlenOpts
  local hLen=$(strlen "${INPUT_INFO[@]}")
  local variables=("${INPUT_OPTIONS_V[@]}" "${INPUT_ARG_S[@]}")
  local variablesLen

  # Print tool header
  if [ ${#INPUT_INFO[@]} -ne 0 ]; then
    for var in "${INPUT_INFO[@]}"; do
      printf "\n\033[${FAF}m %s\033[${FN}m" "$var"
    done
    printf "\n \033[${FA}m%${hLen}s\033[${FN}m" "Version $INPUT_APP_V"
  else
    app_head
  fi

  if [ ! -z "${INPUT_COMMANDS_CURRENT}" ]; then
    i=0
    for var in "${INPUT_COMMANDS[@]}"; do
      if [[ "$var" == "$INPUT_COMMANDS_CURRENT" ]]; then
        printf "\n\n\033[${FAF}m  %s\033[${FN}m" "${INPUT_COMMANDS_D[$i]}"
      fi
      i=$(($i+1))
    done
  fi

  # Usage header
  printf "\n\n\033[${FP}mUsage:\033[${FN}m\n\n"
  printf "  \033[${FAF}m$INPUT_SCRIPTNAME\033[${FN}m [options]"

  # Merge options and arbuments command specific
  if [ ! -z "${INPUT_COMMANDS_CURRENT}" ]; then
    eval "options=(\"\${options[@]}\" \"\${${INPUT_COMMANDS_CURRENT}_INPUT_OPTIONS[@]}\")"  
    eval "options_d=(\"\${options_d[@]}\" \"\${${INPUT_COMMANDS_CURRENT}_INPUT_OPTIONS_D[@]}\")"  
    eval "options_v=(\"\${options_v[@]}\" \"\${${INPUT_COMMANDS_CURRENT}_INPUT_OPTIONS_V[@]}\")"  
    eval "args=(\"\${args[@]}\" \"\${${INPUT_COMMANDS_CURRENT}_INPUT_ARGS[@]}\")"
    eval "args_d=(\"\${args_d[@]}\" \"\${${INPUT_COMMANDS_CURRENT}_INPUT_ARGS_D[@]}\")"
    eval "variables+=(\"\${${INPUT_COMMANDS_CURRENT}_INPUT_OPTIONS_V[@]}\" \"\${args[@]}\")"

    # List of attributes and option names to setup optimal length of attrib. name column width
    vLenOpts=("${options[@]}" "${args[@]}")

    # Check if command specific spread attribute is defined
    is=$(eval "echo \${${INPUT_COMMANDS_CURRENT}_INPUT_ARG_S}")

    # Override default spread attribute
    if [ ! -z "${is}" ]; then
      arg_s="$is"
      eval "arg_s_d=\${${INPUT_COMMANDS_CURRENT}_INPUT_ARG_S_D}"
      vLenOpts+=("$arg_s\[\]")
      variables+=("$arg_s")
    fi

    # Maximum lenght of attribute names to nice printing
    vLen=$(strlen "${vLenOpts[@]}")
    printf " \033[${FAF}m%s\033[${FN}m" "$INPUT_COMMANDS_CURRENT"

    # Display usage of command
  else
    vLen=$(strlen "${options[@]} ${args[@]} ${INPUT_COMMANDS[@]}")

    # Display global usage
    if [ "${#INPUT_COMMANDS[@]}" -ne 0 ]; then
      # when commands are defined
      printf " {command}"
    fi
  fi

  # Calculate variables column width
  variablesLen=$(strlen "${variables[@]}");

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
    if [ "$verbose" == "yes" ]; then
      printf "  \033[${FA}m%-${vLen}s\033[${FN}m  \033[${FAF}m\$%-${variablesLen}s\033[${FN}m %s\n" "$var" "${options_v[$i]}" "${options_d[$i]}"
    else
      printf "  \033[${FA}m%-${vLen}s\033[${FN}m  %s\n" "$var" "${options_d[$i]}"
    fi
    i=$(($i+1))
  done

  if [ "${#args[@]}" -gt 0 ]; then
    # Display available arguments
    i=0
    printf "\n\033[${FP}mArguments:\033[${FN}m\n"
    for var in "${args[@]}"; do
      if [ "$verbose" == "yes" ]; then
        printf "  \033[${FA}m%-${vLen}s\033[${FN}m  \033[${FAF}m\$%-${variablesLen}s\033[${FN}m  %s\n" "$var" "$var" "${args_d[$i]}"
      else
        printf "  \033[${FA}m%-${vLen}s\033[${FN}m  %s\n" "$var" "${args_d[$i]}"
      fi
      i=$(($i+1))
    done
  fi

  # Add Spread argument
  if [ ! -z "${arg_s}" ]; then
    if [ "$verbose" == "yes" ]; then
      printf "  \033[${FA}m%-${vLen}s\033[${FN}m  \033[${FAF}m\$%-${variablesLen}s\033[${FN}m  %s\n" "$arg_s[]" "$arg_s" "$arg_s_d"
    else
      printf "  \033[${FA}m%-${vLen}s\033[${FN}m  %s\n" "$arg_s[]" "$arg_s_d"
    fi
  fi

  # Display available commands only if none is active
  if [ -z "${INPUT_COMMANDS_CURRENT}" ]; then
    i=0
    printf "\n\033[${FP}mCommands:\033[${FN}m\n"
    for var in "${INPUT_COMMANDS[@]}"; do
      printf "  \033[${FA}m%-${vLen}s\033[${FN}m  %s\n" "$var" "${INPUT_COMMANDS_D[$i]}"
      i=$(($i+1))
    done
  fi

  printf "\n"
  exit 0
}

# Parse current args
# - $... List of command line arguments to parse
input_parse() {
  INPUT_COMMANDS_CURRENT=""
  local var i=0 j=0 opt is optV="" optM
  local mergedOpts=("${INPUT_OPTIONS[@]}") 
  local mergedOpts_t=("${INPUT_OPTIONS_T[@]}") 
  local mergedOpts_v=("${INPUT_OPTIONS_V[@]}")
  local mergedOpts_m=("${INPUT_OPTIONS_M[@]}")
  local mergedArgs=("${INPUT_ARGS[@]}")
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
      if [ -z "$INPUT_COMMANDS_CURRENT" -a $i -eq 0 ]; then

        # Iterate through defined commands looking for match
        for j in "${INPUT_COMMANDS[@]}"; do
          if [ "$j" == "$var" ]; then

            # Set current active command
            INPUT_COMMANDS_CURRENT="$var"

            # Update list of available options with command specific 
            eval "mergedOpts=(\"\${INPUT_OPTIONS[@]}\" \"\${${INPUT_COMMANDS_CURRENT}_INPUT_OPTIONS[@]}\")"
            eval "mergedOpts_t=(\"\${INPUT_OPTIONS_T[@]}\" \"\${${INPUT_COMMANDS_CURRENT}_INPUT_OPTIONS_T[@]}\")"
            eval "mergedOpts_v=(\"\${INPUT_OPTIONS_V[@]}\" \"\${${INPUT_COMMANDS_CURRENT}_INPUT_OPTIONS_V[@]}\")"
            eval "mergedOpts_m=(\"\${INPUT_OPTIONS_M[@]}\" \"\${${INPUT_COMMANDS_CURRENT}_INPUT_OPTIONS_M[@]}\")"

            # Update args with command specific ones
            eval "mergedArgs=(\"\${INPUT_ARGS[@]}\" \"\${${INPUT_COMMANDS_CURRENT}_INPUT_ARGS[@]}\")"
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
  if [ -z "$INPUT_COMMANDS_CURRENT" ]; then
    mergedArg_s="$INPUT_ARG_S" 
  else
    eval "mergedArg_s=\${${INPUT_COMMANDS_CURRENT}_INPUT_ARG_S}"
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
        eval "${var}='no'"
      fi
    fi
    i=$(($i+1))
  done
}