describe_cryfs(){
  echo "A cryptographic file system."
}

listcmd_cryfs(){
  echo "cryfs"
}

install_cryfs(){
  if [ ! "$OS" = "linux" ]; then
    echo_error "installing cryfs is currently only implemented for linux"
    return 1
  fi

  echo_yellow "Installing cryfs"
  sudo apt install -y libcurl4-openssl-dev libssl-dev libfuse-dev
  pip install conan
  cd ~ && git clone https://github.com/cryfs/cryfs.git cryfs && cd cryfs
  mkdir build && cd build
  conan install .. --build=missing -s compiler.libcxx=libstdc++11
  cmake ..
  make && sudo make install
  cd ~ && rm -rf cryfs
}

uninstall_cryfs(){
  read -p "Do you really want to uninstall cryfs [y/n]? " -n 1 -r
  echo
  if [ ! "$REPLY" = Y ] && [ ! "$REPLY" = y ]; then
    echo_red "Exiting." && exit 0
  else
    echo_yellow "Uninstalling cryfs"
    sudo rm -rf /home/marcus/cryfs
    sudo rm -rf /usr/local/bin/cryfs
    sudo rm -rf /usr/local/bin/cryfs-unmount
    echo "done."
  fi
}
