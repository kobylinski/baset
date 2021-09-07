# Array helpers
###############################################################################
# Last removed index from array 
# Used by:
#   tool_array_shift
#   tool_array_pop
###############################################################################
TOOL_ARRAY_LAST_ITEM=""

###############################################################################
# Prints last item of array
# Globals:
#   Global variable which name is passed in first argument
# Arguments:
#   Array variable name
# Outputs:
#   Last item value
# Returns:
#   0 on success
#   1 missing first argument
#   2 fist argument is not an array
#   2 if array is empty
###############################################################################
tool_array_last() {
  [[ $# -eq 1 ]] || return 1
  tool_array_is $1 -ne 0 || return 2
  local size
  eval "size=\${#$1[@]}"
  if [[ $size -gt 0 ]]; then
    eval "echo \"\${$1[\${#$1[@]}-1]}"\"
    return 0
  fi
  return 3
}

###############################################################################
# Append array
# Globals:
#   Global variable which name is passed in first argument
# Arguments:
#   Array variable name
#   Appended value
# Returns:
#   0 on success
#   1 missing first argument
#   2 fist argument is not an array
###############################################################################
tool_array_push() {
  [[ $# -eq 2 ]] || return 1
  tool_array_is $1 -eq 0 || return 2
  eval "$1+=(\"\$2\")"
  return 0
}

###############################################################################
# Remove last element from array and put it to global variable
# Globals:
#   TOOL_ARRAY_LAST_ITEM
#   Global variable which name is passed in first argument
# Arguments:
#   Array variable name
# Returns:
#   0 on success
#   1 mising argument
#   2 argument is not an array name
#   3 if array is empty
###############################################################################
tool_array_pop() {
  [[ $# -eq 1 ]] || return 1
  tool_array_is $1 -eq 0 || return 2
  local size
  eval "size=\${#$1[@]}"
  if [[ $size -gt 0 ]]; then
    local last=$(( $size - 1 ))
    eval "TOOL_ARRAY_LAST_ITEM=\${$1[$last]}"
    eval "$1=(\"\${$1[@]:0:$last}\")"
    return 0
  fi
  return 3
}

###############################################################################
# Prepend element to array
# Globals:
#   Global variable which name is passed in first argument
# Arguments:
#   Array variable name
#   Prepended value
# Returns:
#   0 on success
#   1 mising argument
#   2 first argument is not an array name
###############################################################################
tool_array_unshift() {
  [[ $# -eq 2 ]] || return 1
  tool_array_is $1 -eq 0 || return 2
  eval "$1=(\"\$2\" \"\${$1[@]}\")"
  return 0
}

###############################################################################
# Remove first element from array and put it to global variable
# Globals:
#   TOOL_ARRAY_LAST_ITEM
#   Global variable which name is passed in first argument
# Arguments:
#   Array variable name
# Returns:
#   0 on success
#   1 mising argument
#   2 argument is not an array name
#   3 if array is empty
###############################################################################
tool_array_shift() {
  [[ $# -eq 1 ]] || return 1
  tool_array_is $1 -eq 0 || return 2
  local size
  eval "size=\${#$1[@]}"
  if [[ $size -gt 0 ]]; then
    eval "TOOL_ARRAY_LAST_ITEM=\${$1[0]}"
    eval "$1=(\${$1[@]:1})"
    return 0
  fi
  return 3 
}

###############################################################################
# Check if given variable is declared as array
# Globals:
#   Global variable which name is passed in first argument
# Arguments:
#   Array variable name
# Returns:
#   0 is array
#   1 is not an array
###############################################################################
tool_array_is() {
  declare -p $1 2> /dev/null | grep -q '^declare \-a'
}

###############################################################################
# Check if given value exists in array
# Globals:
#   Global variable which name is passed in first argument
# Arguments:
#   Array/haystack variable name
#   Nidle
# Returns:
#   0 is array
#   1 is not an array
###############################################################################
tool_array_in() {
  [[ $# -eq 2 ]] || return 1
  tool_array_is $1 -eq 0 || return 2
  local i size var
  eval "size=\${#$1[@]}"
  for ((i=1; i<=size; i++)); do
    eval "var=\${$1[$i]}"
    if [[ $var == $2 ]]; then
      return 0
    fi
  done
  return 3
}