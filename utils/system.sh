set_config(){
  if [ -z "$1" ] || [ -z "$2" ]; then
    echo -e "\033[31mset_config needs a variable name and a value to set\033[0m"
  elif [ -z "$CONFIG" ]; then
    echo -e "\033[31mCONFIG environment variable is not set\033[0m"
  elif grep -q "$1=" "$CONFIG"; then
    sed -i "s/^\($1\s*=\s*\).*\$/\1$2/" "$CONFIG"
  else
    echo "$1=$2" >> "$CONFIG"
  fi
}

check_if_linux(){
  if [ -z "$OS" ]; then
    read -p "Are you on linux [y/n]? " -n 1 -r
    echo
    if [ "$REPLY" = Y ] || [ "$REPLY" = y ]; then
      OS="linux"
    else
      OS="not_linux"
    fi
  fi
}

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
