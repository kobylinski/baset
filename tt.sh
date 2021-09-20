#!/bin/sh
IFS=""

while read -r -d '<' ca || [[ -n $ca ]]; do
  printf "$ca" | hexdump -C
  while IFS="" read -r -d '>' cb || [[ -n $cb ]]; do
    printf $cb
  done <<< $ca
done <<< "\n\nq>pa<aaa>aa<ppp>pp\n\n"



# source ./src/colors.sh
# source ./src/symbols.sh
# source ./src/lib/tool/string.sh
# source ./src/lib/app/name.sh
# source ./src/lib/input/args.sh

# app_info  "  _____  _____  _____  _____  _____  " \
#           " | __  ||  _  ||   __||   __||_   _| " \
#           " | __ -||     ||__   ||   __|  | |   " \
#           " |_____||__|__||_____||_____|  |_|   "

# app_name "Baset" "0.0.1"

# input_cmd "command1" "Command info"
# input_cmd "command2" "Command info"


# # INPUT_COMMANDS_CURRENT=""

# input_print_help

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

