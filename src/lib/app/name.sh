
###############################################################################
# Add Application name and version
# Globals:
#   APP_NAME
#   APP_V
# Arguments:
#   Name of application
#   Version of application
# Returns:
#   0 on success
#   1 if missing arguments
#   2 if name and version already defined
###############################################################################
app_name() {
  [[ $# -eq 2 ]] || return 1
  if [[ ! -z $APP_NAME ]] || [[ ! -z $APP_V ]]; then 
    return 2
  fi
  readonly APP_NAME=$1
  readonly APP_V=$2
}

###############################################################################
# Add multiline banner
# Globals:
#   APP_INFO
# Arguments:
#   List of lines of app info
###############################################################################
app_info() {
  [[ $# -eq 0 ]] && return 1
  [[ ! -z $APP_INFO ]] && return 2
  readonly APP_INFO=( "$@" )
}