###############################################################################
# General format of list
# Used by:
#   output_list
###############################################################################
OUTPUT_LIST_FORMAT="<PRIMARY_FADE;IMPORTANT>%s</> <PRIMARY>%s</>\n"

###############################################################################
# Prints list
# Globals:
#   OUTPUT_LIST_FORMAT
# Arguments:
#   List prefix, it can be # character represents ordered list or any other
#     character with indentation
#   List of elements
# Output:
#   Formated list
# Returns:
#   0 on success
#   1 no arguments
###############################################################################
output_list() {
  [[ $# -gt 1 ]] || return 1
  local prefix=$1
  local cp=${#prefix}
  shift
  local count=$#
  local cc=${#count} line
  local ca=$(( $cc + $cp - 1 ))
  local format

  # Ordered list
  if [[ $prefix =~ \#$ ]]; then
    local i=1
    format=$(printf "$OUTPUT_LIST_FORMAT" "%${ca}s." "%s")
    for line in "$@"; do
      tool_string_format "$format" "$i" "$line"
      i=$(($i+1))
    done
    return 0
  fi

  # Bullet list
  format=$(printf "$OUTPUT_LIST_FORMAT" "%${ca}s" "%s")
  for line in "$@"; do
    tool_string_format "$format" "$prefix" "$line"
  done
  return 0
}


###############################################################################
# Prints ordered list
# Arguments:
#   List of fields
# Returns:
#   0 on success
#   1 no arguments
###############################################################################
output_ordered_list() {
  output_list " #" "$@"
}

###############################################################################
# Prints bullet list
# Globals:
#   SYMBOL_BULLET
# Arguments:
#   List of fields
# Returns:
#   0 on success
#   1 no arguments
###############################################################################
output_bullet_list() {
  output_list " ${SYMBOL_BULLET}" "$@"
}