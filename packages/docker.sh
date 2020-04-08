describe_docker(){
  echo "Latest stable docker release for distribution."
}

listcmd_docker(){
  echo "docker"
}

install_docker(){
  if [ ! "$OS" = "linux" ]; then
    echo_error "installing docker is currently only implemented for linux"
    return 1
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

uninstall_docker(){
  if [ ! "$OS" = "linux" ]; then
    echo_error "uninstalling docker is currently only implemented for linux"
    return 1
  fi

  read -p "Do you really want to uninstall docker [y/n]? " -n 1 -r
  echo
  if [ ! "$REPLY" = Y ] && [ ! "$REPLY" = y ]; then
    echo_red "Exiting." && exit 0
  else
    echo_yellow "Uninstalling docker"
    sudo apt-get -y purge '^docker-.*'
    sudo apt-get -y purge containerd runc
    sudo apt-get -y autoremove
  fi
}
