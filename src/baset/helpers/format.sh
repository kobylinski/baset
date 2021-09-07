###############################################################################
# Prints preview of all defined formats
# Globals:
#   Each of value with prefix FORMAT_
# Outputs:
#   Preview of all predefined styles
###############################################################################
baset_helpers_formats() {
  local var val i=0
  local vars IFS=' '
  read -r -a vars <<< ${!FORMAT_*}
  local varsLen=$(tool_string_len ${vars[@]})
  local vals=()
  for var in "${vars[@]}"; do
    vals+=("$(tool_string_value $var)")
  done
  local valsLen=$(tool_string_len ${vals[@]})
  for var in "${vars[@]}"; do
    printf "\033[%sm %-${varsLen}s %-${valsLen}s \033[${FORMAT_RESET}m\n" "${vals[$i]}" "$var" "${vals[$i]}"
    i=$(($i+1))
  done
}