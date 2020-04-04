describe_defaults(){
  echo "Basic utilities including oh my zsh, tmux and fzf."
}

install_defaults(){
  install_"$OS"
}

install_linux(){
  echo_yellow "Installing linux defaults"
  cd ~

  echo_yellow "Installing default packages"
  sudo apt update && sudo apt install -y \
    vim-gnome \
    zsh \
    git \
    curl \
    htop \
    bmon \
    ncdu \
    ecryptfs-utils

  echo_yellow "Installing powerline fonts"
  git clone https://github.com/powerline/fonts.git --depth=1
  cd fonts
  ./install.sh
  cd ..
  rm -rf fonts

  echo_yellow "Installing Oh my zsh"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

  echo_yellow "Setting up dotfiles"
  mkdir ~/.dotfiles
  git clone https://github.com/mawall/dotfiles ~/.dotfiles
  link_dotfiles
  git config --global core.excludesfile ~/.gitignore_global

  echo_yellow "Installing tmux"
  sudo apt-get update
  sudo apt-get install tmux
  git clone https://github.com/jimeh/tmux-themepack.git ~/.tmux-themepack
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

  echo_yellow "Installing fzf"
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install

  echo_yellow "Successfully installed linux defaults"
}

install_mac(){
  echo_yellow "Installing mac defaults"
  cd ~

  echo_yellow "Installing homebrew"
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

  echo_yellow "Installing default packages"
  brew cask install oxfuse
  brew install cryfs

  echo_yellow "Installing powerline fonts"
  git clone https://github.com/powerline/fonts.git --depth=1
  cd fonts
  ./install.sh
  cd ..
  rm -rf fonts

  echo_yellow "Installing Oh my zsh"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

  echo_yellow "Setting up dotfiles"
  mkdir ~/.dotfiles
  git clone https://github.com/mawall/dotfiles ~/.dotfiles
  link_dotfiles
  git config --global core.excludesfile ~/.gitignore_global

  echo_yellow "Installing tmux"
  brew install tmux
  git clone https://github.com/jimeh/tmux-themepack.git ~/.tmux-themepack

  echo_yellow "Installing fzf"
  brew install fzf
  "$(brew --prefix)"/opt/fzf/install

  echo_yellow "Successfully installed mac defaults"
}