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
# Check if given variable is defined and its string
# Arguments:
#   Variable name
# Returns:
#   0 yes
#   1 no
###############################################################################
tool_string_is() {
  declare -p $1 2> /dev/null | grep -q "^declare -- $1=\""
}

###############################################################################
# Prints value of variable based on its name
# Arguments:
#   Variable name
# Outputs:
#   Variable value
###############################################################################
tool_string_value() {
  eval "printf \$$1"
}

###############################################################################
# Output formated string based on pseudo html tags
# Globals:
#   no_color
#   FORMAT_RESET
#   FORMAT_*
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

  # value of format string
  local format

  # helper variables
  local ca cb cc sa sb sc IFS=

  # chunks iterators
  local i=0 j=0

  # switch off
  if [ -z ${no_color+x} ]; then
    local no_color="no"
  fi

  # cut string using start of tags
  # unformatted text < [format definition & formatted text or reset tag]
  while read -d '<' ca || [[ -n $ca ]]; do

    # next chunks
    # (<) formatted definition & formatted text or reset tag
    if [[ $i -gt 0 ]]; then
      sa=""
      j=0

      # cuts chunk using closing tag format definition '>'
      # (<) format definition > formatted text or (<) /
      while read -d '>' cb || [[ -n $cb ]]; do

        # drops end of line from subchunk
        cb=${cb%$'\n'*}

        # is its a string after tag
        if [[ $j -gt 0 ]]; then
          sa="$sa$cb"
        else

          # if its reset tag </>
          if [[  $cb == "/" ]]; then
            if [[ $no_color == "no" ]]; then
              sa="$sa${FORMAT_RESET}m"
            fi

          # if its format
          else
            sb=""

            # cuts format string constants with ; as separator
            # ( < ) FORMAT1 ';' FORMAT2 ';' ... '>' 
            while read -d ';' cc || [[ -n $cc ]]; do
              
              # drops end of line from subchunk
              cc=${cc%$'\n'*}
              sc=""
              if [[ ! -z $cc ]]; then

                # checks if format constant exists
                if tool_string_is "FORMAT_$cc"; then

                  # read format string from predefined constant
                  sc="$sc$(tool_string_value "FORMAT_$cc")"
                fi

                # once one style is defined next style is glued with ;
                if [[ ! -z $sb ]]; then
                  sc=";$sc"
                fi
              fi

              # glue style with one prevously defined
              sb="$sb$sc"
            done <<< $cb

            # finish style string with 
            if [[ $no_color == "no" ]]; then
              sa="$sa${sb}m"
            fi
          fi
        fi

        j=$(($j + 1))
      done <<< $ca

      # glue formatted string with previously defined
      if [[ $no_color == "yes" ]]; then
        format="$format$sa"
      else
        format="${format}\033[${sa}"
      fi
    
    # first chunk (unformatted string)
    else
      format="$ca"
    fi

    # iterate number of chunks
    i=$(($i + 1))
  done <<< $1
  shift

  # outputs formatted string
  printf $format $@
}