install_nvtop(){
  check_if_linux && if [ ! "$OS" = "linux" ]; then
    echo_red "nvtop installation is currently only implemented for linux" && return 1
  fi

  cd ~ && echo_yellow "Installing nvtop"
  sudo apt install cmake libncurses5-dev libncursesw5-dev git
  git clone https://github.com/Syllo/nvtop.git
  mkdir -p nvtop/build && cd nvtop/build
  cmake ..
  make && sudo make install
  cd ~ && rm -rf nvtop
}