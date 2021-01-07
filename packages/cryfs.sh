describe_cryfs(){
  echo "A cryptographic file system."
}

listcmd_cryfs(){
  echo "cryfs"
}

install_cryfs(){
  install_cryfs_"$OS"
}

install_cryfs_linux(){
  echo_yellow "Installing cryfs"
  sudo apt install -y libcurl4-openssl-dev libssl-dev libfuse-dev
  pip install conan
  cd ~ && git clone https://github.com/cryfs/cryfs.git cryfs && cd cryfs
  mkdir build && cd build
  conan install .. --build=missing -s compiler.libcxx=libstdc++11
  cmake ..
  make && sudo make install
  cd ~ && rm -rf cryfs
  echo_yellow "Successfully installed cryfs"
}

install_cryfs_mac_os(){
  echo_yellow "Installing cryfs"
  brew install --cask osxfuse
  brew install cryfs
  echo_yellow "Successfully installed cryfs"
  echo_yellow "You must reboot for the installation of osxfuse to take effect"
}

uninstall_cryfs(){
  uninstall_cryfs_"$OS"
}

uninstall_cryfs_linux(){
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

uninstall_cryfs_mac_os(){
  read -p "Do you really want to uninstall cryfs [y/n]? " -n 1 -r
  echo
  if [ ! "$REPLY" = Y ] && [ ! "$REPLY" = y ]; then
    echo_red "Exiting." && exit 0
  else
    echo_yellow "Uninstalling cryfs"
    brew uninstall cryfs osxfuse
    echo "done."
  fi
}
