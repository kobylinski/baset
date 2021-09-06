baset_vendor_install() {
  local root=$(baset_root)
  local path=$(baset_path)
  local vendor=$(baset_vendor)

  # Ensure that .baset file exists
  if [ ! -f "$path" -a -w "$root" ]; then
    touch "$path"
  fi

  # Ensure that vendor directory already exists
  if [ ! -d "$vendor" ]; then
    mkdir "$vendor"
  fi

  local repo=$(cat $path)
  local line data i response

  # List of selected repositories to install
  local installNames=() # Repository name represents target directory or file in vendor directory
  local installUrls=()  # Repository source url
  local installType=()  # Repository type: http file or git repository

  # Installation status
  # 0 - ready
  # 1 - already installet
  # 2 - not available
  # 3 - invalid type
  local installStatus=()

  # Loop through the manifest file
  while IFS=',' read -ra line; do
      installNames+=("${line[0]}")
      installUrls+=("${line[1]}")
      case "${line[1]}" in

        # Git repository adapter
        git@*)
          installType+=("git")
          if [ -d "$vendor/${line[0]}" ]; then
            installStatus+=(1)
          else
            git ls-remote -h "${line[1]}" --exit-code  &> /dev/null
            response=$?
            if [ "$response" -eq 0 ]; then
              installStatus+=(0)
            else
              installStatus+=(2)
            fi
          fi
          ;;

        # Remote file adapter
        http*)
          installType+=("file")
          # Omit if file exists
          if [ ! -f "$vendor/${line[0]}" ]; then
            # Check if file is available by remote
            file_http_available "${line[1]}"
            if [ $? -eq 0 ]; then
              installStatus+=(0)
            else
              installStatus+=(2)  
            fi
          else
            installStatus+=(1)
          fi
          ;;
        *)
          installType+=("unknown")
          installStatus+=(3)
          ;;
      esac
  done <<< "$repo"

  # Format response raport to be nice and readable
  local vLength=$(strlen "${installNames[@]}") name;
  i=0
  for name in "${installNames[@]}"; do
    printf "\033[${FPF}mInstalling \033[${FN}m%-${vLength}s   " "$name"
    case "${installStatus[$i]}" in
      0)
        case "${installType[$i]}" in
          git)
            git clone "${installUrls[$i]}" $vendor/$name &> /dev/null
            if [ -d "$vendor/$name/.git" ]; then
              printf "  \033[${FS}m done \033[${FN}m\n"
            else
              printf "  \033[${FE}m error during loading \033[${FN}m\n"
            fi
            ;;
          file)
            file_http_get "${installUrls[$i]}" "$vendor/$name"
            if [ $? -eq 0 ]; then
              printf "  \033[${FS}m done \033[${FN}m\n"
            else
              printf "  \033[${FE}m error during loading \033[${FN}m\n"
            fi
            ;;
        esac
        ;;
      1)
        printf "  \033[${FS}m already installed \033[${FN}m\n"
        ;;
      2)
        printf "  \033[${FE}m repository not available \033[${FN}m\n"
        ;;
      3)
        printf "  \033[${FW}m invalit type \033[${FN}m\n"
        ;;
      *)
        printf "  \033[${FW}m invalid status \033[${FN}m\n"
        ;;
    esac
    i=$(($i+1))
  done
}