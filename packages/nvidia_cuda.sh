describe_nvidia_cuda(){
  echo "Installs kernel headers and latest cuda packages."
}

install_nvidia_cuda(){
  if [ ! "$OS" = "linux" ]; then
    echo_red "installing nvidia_cuda is currently only implemented for linux" && return 1
  fi

  cd ~ && echo_yellow "Installing nvidia cuda"
  sudo apt-get -y install linux-headers-"$(uname -r)"
  sudo apt-get -y purge nvidia-cuda*

#  # Manual install of cuda dependencies, if we don't use apt:
#  sudo apt-get install freeglut3 freeglut3-dev libxi-dev libxmu-dev
#  # Get right cuda version for architecture from https://developer.nvidia.com/cuda-downloads
#  wget http://developer.download.nvidia.com/compute/cuda/10.2/Prod/local_installers/cuda_10.2.89_440.33.01_linux.run
#  sudo sh cuda_10.2.89_440.33.01_linux.run --override

  sudo apt-get -y install nvidia-cuda-dev nvidia-cuda-doc nvidia-cuda-gdb nvidia-cuda-toolkit nvidia-container-runtime

  sudo systemctl restart docker
}