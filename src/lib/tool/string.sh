###############################################################################
# Calculate higher count of letters in provided strings
# Arguments:
#   List of strings
# Outputs:
#   Writes higher string size form given in arguments
# Returns:
#   0 on success
#   1 missing any argument
###############################################################################
tool_string_len(){
  [[ $# -eq 0 ]] && return 1 
  local size=0 line realLine realLineSise
  for line in "$@"; do
    realLine=$(echo $line | sed 's/\\033\[[0-9;]*m//g')
    realLineSise=${#realLine}
    if [ $size -lt $realLineSise ]; then
      size=$realLineSise
    fi
  done
  echo $size;
  return 0
}

###############################################################################
# Check if given variable is defined and its string
# Arguments:
#   Variable name
# Returns:
#   0 yes
#   1 no
###############################################################################
tool_string_is() {
  declare -p $1 2> /dev/null | grep -q "^declare -- $1=\""
}

###############################################################################
# Prints value of variable based on its name
# Arguments:
#   Variable name
# Outputs:
#   Variable value
###############################################################################
tool_string_value() {
  eval "printf \$$1"
}

###############################################################################
# Output formated string based on pseudo html tags
# Arguments:
#   Format string
#   List of extra arguments
# Outputs:
#   Formatted string based on pseudo tags
# Returns:
#   0 on success
#   1 missing arguments
###############################################################################
tool_string_format(){
  [[ $# -eq 0 ]] && return 1
  local ca cb cc format sa sb sc i=0 IFS=
  while read -d '<' ca || [[ -n $ca ]]; do
    if [[ $i -gt 0 ]]; then
      sa=""
      while read -d '>' cb || [[ -n $cb ]]; do
        cb=${cb%$'\n'*}
        if [[ ! -z $sa ]]; then
          sa="$sa$cb"
        else
          if [[  $cb == "/" ]]; then
            sa="$sa${FORMAT_RESET}m"
          else
            sb=""
            while read -d ';' cc || [[ -n $cc ]]; do
              cc=${cc%$'\n'*}
              sc=""
              if [[ ! -z $cc ]]; then
                if tool_string_is "FORMAT_$cc"; then
                  sc="$sc$(tool_string_value "FORMAT_$cc")"
                fi
                if [[ ! -z $sb ]]; then
                  sc=";$sc"
                fi
              fi
              sb="$sb$sc"
            done <<< $cb
            sa="$sa${sb}m"
          fi
        fi
      done <<< $ca
      format="${format}\033[${sa}"
    else
      format="$ca"
    fi
    i=$(($i + 1))
  done <<< $1
  printf $format "${@:2}"
  return 0
}