#!/bin/sh





source ./src/colors.sh
source ./src/tool/string.sh
# source ./src/output/error.sh
# source ./src/output/warning.sh

tool_string_format "before content <FS> %s <FSF> %s2 </> " "qpa1" "qpa2"


# app_name() {
#   if [[ -z $APP_NAME ]] && [[ -z $APP_V ]]; then
#     if [[ -z $1 ]]; then
#       output_error "Missing application name"
#       return 1
#     fi
#     readonly APP_NAME=$1
#     readonly APP_V=$2
#     return 0
#   fi

#   if [[ $# -eq 0 ]]; then
#     printf "\033[${FA}m%s\033[${FN}m" "$APP_NAME"
#     if [[ ! -z $APP_V ]]; then 
#       printf " version \033[${FP}m%s\33[${FN}m" "$APP_V"
#     fi
#     printf "\n"
#     return 0
#   fi 

#   output_warning "Application name already defined"
#   return 2
# }

# app_name "Baset" "v1.3.3"
# app_name
# echo $?
