#--------------------------------------------------------------------
# Display warning message
# Arguments:
#   Warning message
#   List of additional lines of message
# Outputs:
#   Formatted warning message
#--------------------------------------------------------------------
output_warning() {
  local line
  local addLinesLen=$(tool_strlen "WARNING: $1" "${@:2}")
  local len="$(($addLinesLen + 4))"
  local titleLen=$(($len - 10))
  printf "\033[${FI};${FWF}m%s\033[${FN}m" " WARNING: "
  printf "\033[${FW}m%-${titleLen}s\033[${FN}m\n" "$1"
  if [ $# -gt 1 ]; then
    local pointLen=$(($len - 3))
    for line in "${@:2}"; do
      printf "\033[${FI};${FWF}m %s \033[${FN}m" $'\xE2\x80\xa2'
      printf "\033[${FWF}m%-${pointLen}s\033[${FN}m\n" "$line"
    done
  fi
}