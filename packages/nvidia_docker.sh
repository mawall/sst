install_nvidia_docker(){
  check_if_linux && if [ ! "$OS" = "linux" ]; then
    echo_red "nvidia-docker installation is currently only implemented for linux" && return 1
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
}