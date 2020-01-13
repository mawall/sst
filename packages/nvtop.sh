install_nvtop(){
  if [ ! "$OS" = "linux" ]; then
    echo_red "uninstalling nvidia software is currently only implemented for linux" && return 1
  fi

  cd ~ && echo_yellow "Installing nvtop"
  sudo apt install cmake libncurses5-dev libncursesw5-dev git
  git clone https://github.com/Syllo/nvtop.git
  mkdir -p nvtop/build && cd nvtop/build
  cmake ..
  make && sudo make install
  cd ~ && rm -rf nvtop
}