file_http_available() {
  local response=$(curl --write-out '%{http_code}' --silent -o /dev/null -I "${1}")
  if [ "$response" -eq 200 ]; then
    return 0
  fi
  return 1
}

file_http_get() {
  local source=$1
  local target=$2
  
  if [ ! -d "${target%/*}" ]; then
    mkdir -p "${target%/*}"
  fi  

  local response=$(curl --write-out '%{http_code}' --silent -o "$target" "$source")
  if [ "$response" -eq 200 ]; then
    return 0
  fi
  return 1
}