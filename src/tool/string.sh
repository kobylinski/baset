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