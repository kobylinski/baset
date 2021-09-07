###############################################################################
# Error message format
# Used by:
#   output_error
###############################################################################
OUTPUT_ERROR_MESSAGE="<IMPORTANT;ERROR_FADE>%s</><ERROR>%s</>\n"
OUTPUT_ERROR_INFO="<IMPORTANT;ERROR_FADE> $SYMBOL_BULLET</><ERROR_FADE> %s</>\n"
###############################################################################
# Warning message format
# Used by:
#   output_warning
###############################################################################
OUTPUT_WARNING_MESSAGE="<IMPORTANT;WARNING_FADE>%s</><WARNING>%s</>\n"
OUTPUT_WARNING_INFO="<IMPORTANT;WARNING_FADE> $SYMBOL_BULLET</><WARNING_FADE> %s</>\n"
###############################################################################
# Success message format
# Used by:
#   output_success
###############################################################################
OUTPUT_SUCCESS_MESSAGE="<IMPORTANT;SUCCESS_FADE>%s</><SUCCESS>%s</>\n"
OUTPUT_SUCCESS_INFO="<IMPORTANT;SUCCESS_FADE> $SYMBOL_BULLET</><SUCCESS_FADE> %s</>\n"

###############################################################################
# Display message format
# Arguments:
#   Message format
#   Message label
#   Info format
#   Error message
#   List of additional lines of message
# Outputs:
#   Formatted message
# Returns:
#   0 on success
#   1 missing any argument
###############################################################################
output_message() {
  [[ $# -lt 4 ]] && return 1
  local messageFormat=$1; shift
  local messageLabel=$1; shift
  local infoFormat=$1; shift
  local len=$(tool_string_len " $messageLabel: $1" "$@") 
  local labelLen="${#messageLabel}"
  len=$(($len + 4))
  local titleFormat=$(printf "$messageFormat" " $messageLabel: " "%-$(($len - $labelLen - 3))s")
  tool_string_format "$titleFormat" "$1"; shift
  [[ $# -eq 0 ]] && return 0
  local line
  local infoFormat=$(printf "$infoFormat" "%-$(($len - 3))s")
  for line in "$@"; do
    tool_string_format "$infoFormat" "$line" 
  done
  return 0
}

###############################################################################
# Display message format
# Globals:
#   OUTPUT_ERROR_MESSAGE
#   OUTPUT_ERROR_INFO
# Arguments:
#   Error message
#   List of additional lines of message
# Outputs:
#   Formatted message
# Returns:
#   0 on success
#   1 missing any argument
###############################################################################
output_error() {
  output_message \
    "$OUTPUT_ERROR_MESSAGE" \
    "ERROR" \
    "$OUTPUT_ERROR_INFO" \
    "$@"
}

###############################################################################
# Display message format
# Globals:
#   OUTPUT_WARNING_MESSAGE
#   OUTPUT_WARNING_INFO
# Arguments:
#   Warning message
#   List of additional lines of message
# Outputs:
#   Formatted message
# Returns:
#   0 on success
#   1 missing any argument
###############################################################################
output_warning() {
  output_message \
    "$OUTPUT_WARNING_MESSAGE" \
    "WARNING" \
    "$OUTPUT_WARNING_INFO" \
    "$@"
}

###############################################################################
# Display message format
# Globals:
#   OUTPUT_SUCCESS_MESSAGE
#   OUTPUT_SUCCESS_INFO
# Arguments:
#   Success message
#   List of additional lines of message
# Outputs:
#   Formatted message
# Returns:
#   0 on success
#   1 missing any argument
###############################################################################
output_success() {
  output_message \
    "$OUTPUT_SUCCESS_MESSAGE" \
    "SUCCESS" \
    "$OUTPUT_SUCCESS_INFO" \
    "$@"
}