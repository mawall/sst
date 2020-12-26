function_exists(){
  declare -f $1 > /dev/null
  return $?
}

verify_package_completeness(){
  all_complete=true
  for pn in "${PKG_NAMES[@]}"; do
    if ! function_exists describe_"$pn"; then
      echo_error "Package $pn incomplete: function describe_$pn is missing"
      all_complete=false
    elif ! function_exists install_"$pn"; then
      echo_error "Package $pn incomplete: function install_$pn is missing"
      all_complete=false
    elif ! function_exists uninstall_"$pn"; then
      echo_error "Package $pn incomplete: function uninstall_$pn is missing"
      all_complete=false
    fi
  done
  if [ "$all_complete" = false ] ; then
    exit 1
  fi
}

binary_prompt(){
  read -p "$1" -n 1 -r && echo
  if [ "$REPLY" = Y ] || [ "$REPLY" = y ]; then
    return 0
  else
    return 1
  fi
}

#######################################
# Change values in config files or create key=value pair/config file if it doesn't exist.
# Globals:
#   $CONFIG
#######################################
set_config(){
  if [ -z "$1" ] || [ -z "$2" ]; then
    echo_error "[set_config] Need a variable name and a value to set"
    exit 1
  elif [ -z "$CONFIG" ]; then
    echo_error "[set_config] Need a variable name and a value to set"
    exit 1
  elif grep -q "$1=" "$CONFIG"; then
    sed -i "s/^\($1\s*=\s*\).*\$/\1$2/" "$CONFIG"
  else
    echo "$1=$2" >> "$CONFIG"
  fi
}

check_which_os(){
  if [[ "$OSTYPE" == "linux-gnu" ]]; then
    OS="linux"
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="mac_os"
  else
    echo "Please choose your operating system:"
    choices=("linux" "mac_os")
    display_len=$(( ${#choices[@]} > 10 ? 10 : ${#choices[@]} ))
    OS=$(printf '%s\n' "${choices[@]}" | fzf --height=$display_len)
    if [ -z "$OS" ]; then
      echo_error "[check_which_os] Operating system not specified"
      exit 1
    fi
  fi
}

#######################################
# Verify that homebrew is installed
# Globals:
#   $OS
#######################################
check_homebrew(){
  if [[ "$OS" == "mac_os" ]] && ! type -p brew > /dev/null 2>&1; then
    echo_error "sst requires Homebrew"

    if binary_prompt "Do you want to install it? [y/n]? "; then
      /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" && \
        echo -e "Homebrew installed \n"
    else
      exit 1
    fi
  fi
}

#######################################
# Verify that gawk is installed
# Globals:
#   $OS
#######################################
check_awk(){
  # the below redirect prevents the command line expansion to print parts of the
  # awk version description to the terminal if it contains an empty newline.
  if ! awk --version 2>&1 | grep -q "GNU Awk"; then
    echo_error "sst requires GNU Awk"

    if [[ "$OS" == "linux" ]] && binary_prompt "Do you want to install it? [y/n]? "; then
      sudo apt update && sudo apt install -y gawk && echo -e "GNU Awk installed \n"
    elif [[ "$OS" == "mac_os" ]] && binary_prompt "Do you want to install it? [y/n]? "; then
      brew install gawk && echo -e "GNU Awk installed \n"
    else
      exit 1
    fi
  fi
}

#######################################
# Symlink dotfiles from ~/.dotfiles into home directory
#######################################
link_dotfiles(){
  dotfiles=(~/.dotfiles/.*)
  for p in "${dotfiles[@]}"; do
    f="$(echo $p | tr '/' '\n' | tail -1)"
    if ! grep -Fxq "$f" ~/.dotfiles/.gitignore_global && [ "$f" != '.git' ]
    then
      ln -s ~/.dotfiles/"$f" ~
      echo "Linked $f"
    fi
  done
}

#######################################
# Get package names from filenames in package dir.
# Globals:
#   ROOT_DIR
#   PKG_NAMES
#######################################
get_package_names(){
  shopt -s nullglob
  filenames=("$ROOT_DIR"/packages/*)
  shopt -u nullglob

  if (( ${#filenames[@]} == 0 )); then
    echo_error "No packages found"
  fi

  unset PKG_NAMES
  for f in "${filenames[@]}"; do
    PKG_NAMES+=( "$( echo "$f" | sed -e "s#^${ROOT_DIR}/packages/##; s#.sh\$##" )")
  done
}

#######################################
# Verify if a given string is a package name.
# Globals:
#   PKG_NAMES
# Arguments:
#   Package name to check, a string
# Returns:
#   0 if package name is found, non-zero if not.
#######################################
is_package_name(){
  for pn in "${PKG_NAMES[@]}"; do
      if [ "$pn" == "$1" ] ; then
          return 0
      fi
  done
  return 1
}

get_package_info(){
  get_package_names

  unset PKG_DESC
  for n in "${PKG_NAMES[@]}"; do
    PKG_DESC+=( "$( "describe_$n" )")
  done

  unset PKG_INFO
  for (( i=0; i<${#PKG_NAMES[@]}; ++i)); do
    if [ $i -ne $(( ${#PKG_NAMES[@]} - 1)) ]; then
      PKG_INFO+="${PKG_NAMES[$i]}+++${PKG_DESC[$i]}\n"
    else
      PKG_INFO+="${PKG_NAMES[$i]}+++${PKG_DESC[$i]}"
    fi
  done
}

print_status(){
  for pn in "${PKG_NAMES[@]}"; do
    if function_exists listcmd_"$pn"; then
      IFS=" " read -r -a pkgcmd <<< "$(listcmd_"$pn")"
      CMDS+=( "${pkgcmd[@]}" )
    fi
  done
  for cmd in "${CMDS[@]}"; do
    if type -p "$cmd" > /dev/null 2>&1; then
      echo_green "$cmd"
    else
      echo_red "$cmd"
    fi
  done
}
