install_mac(){
  echo_yellow "Installing mac defaults"
  cd ~

  echo_yellow "Installing homebrew"
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

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