describe_trackpoint_config(){
  echo "Sensitivity and speed settings for ThinkPad trackpoints."
}

listcmd_trackpoint_config(){
  echo
}

install_trackpoint_config(){
  if [ ! "$OS" = "linux" ]; then
    echo_error "installing fusuma is currently only implemented for linux"
    return 1
  fi

  echo_yellow "Installing trackpoint config"
  sudo apt install xserver-xorg-input-libinput-hwe-18.04
  cp $ROOT_DIR/config/10-trackpoint.rules /etc/udev/rules.d/10-trackpoint.rules
  cp $ROOT_DIR/config/90-libinput.conf /usr/share/X11/xorg.conf.d/90-libinput.conf
}

uninstall_trackpoint_config(){
  read -p "Do you really want to remove the trackpoint config [y/n]? " -n 1 -r
  echo
  if [ ! "$REPLY" = Y ] && [ ! "$REPLY" = y ]; then
    echo_red "Exiting." && exit 0
  else
    echo_yellow "Removing trackpoint config"
    rm -rf /etc/udev/rules.d/10-trackpoint.rules
    rm -rf /usr/share/X11/xorg.conf.d/90-libinput.conf
  fi
}
