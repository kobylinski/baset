#!/usr/bin/env bash

ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source $ROOT/src/colors.sh
source $ROOT/src/output/strings.sh
source $ROOT/src/output/error.sh
source $ROOT/src/output/warning.sh
source $ROOT/src/output/success.sh
source $ROOT/src/output/list.sh
source $ROOT/src/output/name.sh
source $ROOT/src/input/args.sh
source $ROOT/src/file/http.sh
source $ROOT/src/baset/paths.sh
source $ROOT/src/baset/bootstrap.sh
source $ROOT/src/baset/require.sh
source $ROOT/src/baset/vendor.sh


+info "  _____  _____  _____  _____  _____  " \
      " | __  ||  _  ||   __||   __||_   _| " \
      " | __ -||     ||__   ||   __|  | |   " \
      " |_____||__|__||_____||_____|  |_|   "

+name "Baset"           "0.0.1"
#--------------------------------------------------------------
+cmd  "install"         "Install environment"
+cmd  "require"         "Add package" 
+arg  "name"            "Package unique name"
+arg  "url"             "Url of package, it can be URL to file or Github repository"
+cmd  "merge"           "Merge tool file into file"
+arg  "source"          "Tool filepath"
+arg  "target"          "Target path for result file"
+cmd  "bootstrap"       "Bootstrap new tool file"
+arg  "filename"        "Filename"
baset_args "$@"

if [ "${help}" == "yes" ]; then
  baset_help
fi

case "$BASET_COMMANDS_CURRENT" in
  "install")
    baset_head
    baset_vendor_install
    ;;
  "require")
    baset_head
    echo "requre"
    ;;
  "merge")
    baset_head
    echo "merge"
    ;;
  "bootstrap")
    baset_head
    echo "bootstrap"
    ;;
  *)
    baset_help
    ;;
esac
