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