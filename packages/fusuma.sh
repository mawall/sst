describe_fusuma(){
  echo "Multitouch gestures for Ubuntu."
}


install_fusuma(){
  if [ ! "$OS" = "linux" ]; then
    echo_red "installing fusuma is currently only implemented for linux" && return 1
  fi

  # Install fusuma for trackpad multitouch gestures
  # https://github.com/iberianpig/fusuma/
  echo_yellow "Installing fusuma"
  sudo gpasswd -a $USER input
  sudo apt-get install libinput-tools
  sudo apt-get install ruby
  sudo gem install fusuma
  sudo apt-get install xdotool
  gsettings set org.gnome.desktop.peripherals.touchpad send-events enabled
  sudo gem update fusuma
  # create config file
  mkdir -p ~/.config/fusuma
  cp $ROOT_DIR/config/fusuma.yml ~/.config/fusuma/config.yml
}