describe_nvidia_drivers(){
  echo "Latest stable Nvidia drivers for Ubuntu."
}

listcmd_nvidia_drivers(){
  echo "nvidia-smi"
}

install_nvidia_drivers(){
  if [ ! "$OS" = "linux" ]; then
    echo_error "installing nvidia_drivers is currently only implemented for linux"
    return 1
  fi

  echo_yellow "Installing nvidia drivers"
  sudo apt-get purge nvidia-*

#  # Get right driver for architecture/gpu from https://www.nvidia.com/Download/index.aspx?lang=en-us
#  wget http://uk.download.nvidia.com/XFree86/Linux-x86_64/440.44/NVIDIA-Linux-x86_64-440.44.run
#  sudo sh NVIDIA-Linux-x86_64-440.44.run

  sudo apt-get -y install ubuntu-drivers-common && sudo ubuntu-drivers autoinstall

  echo_yellow "Successfully installed nvidia_drivers"
  echo_yellow "Reboot machine now!" && exit 0
}

uninstall_nvidia_drivers(){
  if [ ! "$OS" = "linux" ]; then
    echo_red "uninstalling nvidia software is currently only implemented for linux" && return 1
  fi

  echo_red "[WARNING] This will uninstall all nvidia software!"
  read -p "Do you really want to uninstall all nvidia software [y/n]? " -n 1 -r
  echo
  if [ ! "$REPLY" = Y ] && [ ! "$REPLY" = y ]; then
    echo_red "Exiting." && exit 0
  else
    sudo apt-get -y purge '^nvidia-.*'
    sudo apt-get -y purge '^libnvidia-.*'
    sudo apt-get -y autoremove
  fi
}
