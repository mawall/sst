function_exists(){
  declare -f $1 > /dev/null
  return $?
}

verify_package_completeness(){
  all_complete=true
  for pn in "${PKG_NAMES[@]}"; do
    if ! function_exists describe_"$pn"; then
      echo_red "Package $pn incomplete: function describe_$pn is missing"
      all_complete=false
    elif ! function_exists install_"$pn"; then
      echo_red "Package $pn incomplete: function install_$pn is missing"
      all_complete=false
    elif ! function_exists uninstall_"$pn"; then
      echo_red "Package $pn incomplete: function uninstall_$pn is missing"
      all_complete=false
    fi
  done
  if [ "$all_complete" = false ] ; then
    exit 1
  fi
}

binary_prompt(){
  # y/n prompts that work in bash and zsh.

  current_shell=$(ps -p "$$" | awk '{if (NR!=1) {print $NF}}')

  if [ "$current_shell" = "zsh" ]; then
    read -k 1 -r "REPLY?$1" && echo
  elif [ "$current_shell" = "bash" ]; then
    read -p "$1" -n 1 -r && echo
  else
    echo -e "\033[31m[binary_prompt] Unrecognised shell\033[0m"
    exit 1
  fi

  if [ "$REPLY" = Y ] || [ "$REPLY" = y ]; then
    return 0
  else
    return 1
  fi
}

set_config(){
  # change values in config files or create key=value pair/config file
  # if it doesn't exist.

  if [ -z "$1" ] || [ -z "$2" ]; then
    echo -e "\033[31m[set_config] Need a variable name and a value to set\033[0m"
    exit 1
  elif [ -z "$CONFIG" ]; then
    echo -e "\033[31m[set_config] CONFIG environment variable is not set\033[0m"
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
    OS="mac-os"
  else
    echo "Please choose your operating system:"
    choices=("linux" "mac-os")
    display_len=$(( ${#choices[@]} > 10 ? 10 : ${#choices[@]} ))
    OS=$(printf '%s\n' "${choices[@]}" | fzf --height=$display_len)
    if [ -z "$OS" ]; then
      echo -e "\033[31m[check_which_os] Operating system not specified\033[0m"
      exit 1
    fi
  fi
}

check_if_linux(){
  if [ -z "$OS" ]; then
    if [ "$OSTYPE" = "linux-gnu" ] || binary_prompt "Are you on linux [y/n]? "; then
      OS="linux"
    else
      OS="other"
    fi
  fi
}

link_dotfiles(){
  # symlink dotfiles from ~/.dotfiles into home directory

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

get_package_names(){
  # get package names from filenames in package dir

  shopt -s nullglob
  filenames=("$ROOT_DIR"/packages/*)
  shopt -u nullglob

  if (( ${#filenames[@]} == 0 )); then
    echo "No packages found" >&2
  fi

  unset PKG_NAMES
  for f in "${filenames[@]}"; do
    PKG_NAMES+=( "$( echo "$f" | sed -e "s#^${ROOT_DIR}/packages/##; s#.sh\$##" )")
  done
}

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
