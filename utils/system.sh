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