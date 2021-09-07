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

###############################################################################
# Output formated string based on pseudo html tags
# Arguments:
#   Format string
#   List of extra arguments
# Outputs:
#   Formatted string based on pseudo tags
# Returns:
#   0 on success
#   1 missing arguments
###############################################################################
tool_string_format(){
  [[ $# -eq 0 ]] && return 1
  local ca cb cc format sa sb sc i=1 IFS=
  while read -d '<' ca || [[ -n $ca ]]; do
    if [[ ! -z $format ]]; then
      sa=""
      while read -d '>' cb || [[ -n $cb ]]; do
        cb=$(echo "$cb" | sed 's/ \n$//g')
        if [[ ! -z $sa ]]; then
          sa="$sa$cb"
        else
          if [[  $cb == "/" ]]; then
            sa="$sa${FN}m"
          else
            sb=""
            while read -d ';' cc || [[ -n $cc ]]; do
              cc=$(echo "$cc" | sed 's/ \n$//g')
              sc=""
              if [[ ! -z $cc ]]; then
                case $cc in
                  FI)   sc="$FI" ;;
                  FE)   sc="$FE" ;;
                  FEF)  sc="$FEF" ;;
                  FW)   sc="$FW" ;;
                  FWF)  sc="$FWF" ;;
                  FS)   sc="$FS" ;;
                  FSF)  sc="$FSF" ;;
                  FP)   sc="$FP" ;;
                  FPF)  sc="$FPF" ;;
                  FA)   sc="$FA" ;;
                  FAF)  sc="$FAF" ;;
                  *)    sc="$cc" ;;
                esac
                if [[ ! -z $sb ]]; then
                  sc=";$sc"
                fi
              fi
              sb="$sb$sc"
            done <<< $cb
            sa="$sa${sb}m"
          fi
        fi
      done <<< $ca
      format="$format\033[${sa}"
    else
      format="$ca"
    fi
  done <<< $1
  printf $format "${@:2}"
  return 0
}