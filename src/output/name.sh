BASET_APP_NAME=
BASET_APP_V=

+name() {
  BASET_APP_NAME=$1
  BASET_APP_V=$2
}

baset_head(){
  printf "\033[${FA}m%s\033[${FN}m" "$BASET_APP_NAME"
  if [ "${BASET_APP_V+x}" ]; then 
    printf " version \033[${FP}m%s\33[${FN}m" "$BASET_APP_V"
  fi
  printf "\n"
}