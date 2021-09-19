# Add Application name and version
# 
# Globals:
#   APP_NAME
#   APP_V
# Arguments:
#   Name of application
#   Version of application
# Outputs:
#   App name with version on
app_name() {
  if [[ -z $APP_NAME ]] && [[ -z $APP_V ]]; then
    readonly APP_NAME=$1
    readonly APP_V=$2
    return 0
  fi

  if [[ $# -eq 0 ]]; then
    printf "\033[${FA}m%s\033[${FN}m" "$APP_NAME"
    if [ "${APP_V+x}" ]; then 
      printf " version \033[${FP}m%s\33[${FN}m" "$APP_V"
    fi
    printf "\n"
  fi
}

# Add multiline banner
# 
# $@ list of lines of banner
app_banner() {
  if [[ -z $APP_INFO ]]; then
    readonly APP_INFO=$@
  else
    if [[  ]]
  fi


  local var
  declare -a APP_INFO
  for var in "$@"; do
    APP_INFO+=( $var )
  done
  declare -r APP_INFO
}