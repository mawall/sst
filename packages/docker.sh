install_docker(){
  check_if_linux && if [ ! "$OS" = "linux" ]; then
    echo_red "docker installation is currently only implemented for linux" && return 1
  fi

  echo_yellow "Installing latest stable docker release"
  sudo apt -y update
  sudo apt -y install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
  sudo apt -y remove docker docker-ce docker-ce-cli docker-engine docker.io containerd runc
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
  sudo apt update
  sudo apt -y install docker-ce docker-ce-cli containerd.io
  sudo usermod -aG docker $USER
  newgrp docker
}