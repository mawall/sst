describe_defaults(){
  echo "Basic utilities including oh my zsh, tmux, fzf, htop, ncdu and Marcus' dotfiles."
}

listcmd_defaults(){
  echo "vim zsh git curl htop bmon ncdu tmux fzf"
}

install_defaults(){
  install_defaults_"$OS"
}

uninstall_defaults(){
  echo_error "Uninstall defaults is not implemented"
}

install_defaults_linux(){
  echo_yellow "Installing linux defaults"
  cd ~

  echo_yellow "Installing default packages"
  sudo apt update && sudo apt install -y \
    vim \
    zsh \
    git \
    curl \
    htop \
    bmon \
    ncdu \
    openssh-server \
    ecryptfs-utils

  echo_yellow "Installing powerline fonts"
  git clone https://github.com/powerline/fonts.git --depth=1
  cd fonts
  ./install.sh
  cd ..
  rm -rf fonts

  echo_yellow "Setting up dotfiles"
  mkdir ~/.dotfiles
  mkdir ~/bin
  git clone https://github.com/mawall/dotfiles.git ~/.dotfiles
  link_dotfiles
  git config --global core.excludesfile ~/.gitignore_global

  echo_yellow "Installing Oh my zsh"
  RUNZSH="no" KEEP_ZSHRC="yes" sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

  echo_yellow "Installing tmux"
  sudo apt-get update
  sudo apt-get install tmux
  git clone https://github.com/jimeh/tmux-themepack.git ~/.tmux-themepack
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

  echo_yellow "Installing fzf"
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install

  configure_vim

  echo_yellow "Successfully installed linux defaults"
  zsh
}

install_defaults_mac_os(){
  echo_yellow "Installing mac_os defaults"
  cd ~

  echo_yellow "Installing default packages"
  brew install htop \
               bmon \
               ncdu

  echo_yellow "Installing powerline fonts"
  git clone https://github.com/powerline/fonts.git --depth=1
  cd fonts
  ./install.sh
  cd ..
  rm -rf fonts

  echo_yellow "Setting up dotfiles"
  mkdir ~/.dotfiles
  mkdir ~/bin
  git clone https://github.com/mawall/dotfiles.git ~/.dotfiles
  link_dotfiles
  git config --global core.excludesfile ~/.gitignore_global

  echo_yellow "Installing Oh my zsh"
  RUNZSH="no" KEEP_ZSHRC="yes" sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

  echo_yellow "Installing tmux"
  brew install tmux
  git clone https://github.com/jimeh/tmux-themepack.git ~/.tmux-themepack
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

  echo_yellow "Installing fzf"
  brew install fzf
  "$(brew --prefix)"/opt/fzf/install

  configure_vim

  echo_yellow "Installing rectangle"
  brew install rectangle

  echo_yellow "Successfully installed mac_os defaults"
  zsh
}

configure_vim(){
#  tic -o ~/.terminfo $ROOT_DIR/config/xterm-256color.terminfo
#  export TERM=xterm-256color

  # Install Vundle
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
  # Install Darcula colortheme
  git clone https://github.com/doums/darcula.git ~/.vim/bundle/darcula
}
