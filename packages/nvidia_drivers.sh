describe_nvidia_drivers(){
  echo "Latest stable Nvidia drivers for Ubuntu."
}

install_nvidia_drivers(){
  if [ ! "$OS" = "linux" ]; then
    echo_red "installing nvidia_drivers is currently only implemented for linux" && return 1
  fi

  echo_yellow "Installing nvidia drivers"
  sudo apt-get purge nvidia-*

#  # Get right driver for architecture/gpu from https://www.nvidia.com/Download/index.aspx?lang=en-us
#  wget http://uk.download.nvidia.com/XFree86/Linux-x86_64/440.44/NVIDIA-Linux-x86_64-440.44.run
#  sudo sh NVIDIA-Linux-x86_64-440.44.run

  sudo apt-get -y install ubuntu-drivers-common && sudo ubuntu-drivers autoinstall

  echo_yellow "Reboot machine now!" && exit 0
}