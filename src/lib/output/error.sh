###############################################################################
# Display error message
# Arguments:
#   Error message
#   List of additional lines of message
# Outputs:
#   Formatted error message
# Returns:
#   0 on success
#   1 missing any argument
###############################################################################
output_error() {
  [[ $# -eq 0 ]] && return 1 
  local len=$(tool_string_len "ERROR: $1" "${@:2}") 
  local line
  len="$(($len + 4))"
  local titleLen="$(($len - 8))"
  printf "\033[${FI};${FEF}m%s\033[${FN}m" " ERROR: "
  printf "\033[${FE}m%-${titleLen}s\033[${FN}m\n" "$1"
  [[ $# -eq 1 ]] && return 0
  local pointLen=$(($len - 3))
  for line in "${@:2}"; do
    printf "\033[${FI};${FEF}m %s \033[${FN}m" $'\xE2\x80\xa2'
    printf "\033[${FEF}m%-${pointLen}s\033[${FN}m\n" "$line"
  done
  return 0
}