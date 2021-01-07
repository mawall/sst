describe_nvidia_docker(){
  echo "Nvidia container toolkit to build and run GPU accelerated Docker containers."
}

install_nvidia_docker(){
  if [ ! "$OS" = "linux" ]; then
    echo_error "installing nvidia_docker is currently only implemented for linux"
    return 1
  fi

  cd ~ && echo_yellow "Installing nvidia-docker"
  # From https://github.com/NVIDIA/nvidia-docker
  # Add the package repositories
  distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
  curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
  curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | \
  sudo tee /etc/apt/sources.list.d/nvidia-docker.list

  sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit
  sudo systemctl restart docker
  echo_yellow "Successfully installed nvidia_docker"
}

uninstall_nvidia_docker(){
  read -p "Do you really want to uninstall nvidia_docker [y/n]? " -n 1 -r
  echo
  if [ ! "$REPLY" = Y ] && [ ! "$REPLY" = y ]; then
    echo_red "Exiting." && exit 0
  else
    echo_yellow "Uninstalling nvidia_docker"
    sudo apt-get -y purge nvidia-docker
    sudo apt-get -y purge nvidia-docker2
  fi
}
