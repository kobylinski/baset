baset_root() {
  if [ -z "$ROOT" ]; then
    die "Variable \$ROOT needs to be defined"
  fi
  if [ -z "$1" ]; then
    echo "$ROOT"
  else
    echo "$ROOT/$1"
  fi
}

baset_path() {
  echo $(baset_root ".baset")
}

baset_vendor() {
  echo $(baset_root "vendor")
}