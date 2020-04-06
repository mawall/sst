describe_nvtop(){
  echo "An htop like GPU status monitor."
}

listcmd_nvtop(){
  echo "nvtop"
}

install_nvtop(){
  if [ ! "$OS" = "linux" ]; then
    echo_red "uninstalling nvidia software is currently only implemented for linux" && return 1
  fi

  cd ~ && echo_yellow "Installing nvtop"
  sudo apt install cmake libncurses5-dev libncursesw5-dev git
  git clone https://github.com/Syllo/nvtop.git
  mkdir -p nvtop/build && cd nvtop/build
  cmake ..
  exit_status=$(make && sudo make install)
  if [ "$exit_status" -eq 0 ]; then
    cd ~ && rm -rf nvtop
  else
    echo_red "Could not install nvtop. Check ~/nvtop for manual installation.

If it errors with 'Could NOT find NVML (missing: NVML_INCLUDE_DIRS)'
try the following commands from ~/nvtop/build instead:

cmake .. -DNVML_RETRIEVE_HEADER_ONLINE=True
make && sudo make install" >&2
  fi
}

uninstall_nvtop(){
  read -p "Do you really want to uninstall nvtop [y/n]? " -n 1 -r
  echo
  if [ ! "$REPLY" = Y ] && [ ! "$REPLY" = y ]; then
    echo_red "Exiting." && exit 1
  else
    echo_yellow "Uninstalling nvtop"
    sudo rm -rf /usr/local/bin/nvtop
    sudo rm -rf /usr/local/man/man1/nvtop.1
    sudo rm -rf /usr/local/share/man/man1/nvtop.1
    echo "done."
  fi
}
