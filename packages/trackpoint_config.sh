describe_trackpoint_config(){
  echo "Sensitivity and speed settings for ThinkPad trackpoints."
}

listcmd_trackpoint_config(){
  echo
}

install_trackpoint_config(){
  if [ ! "$OS" = "linux" ]; then
    echo_error "installing trackpoint config is currently only implemented for linux"
    return 1
  fi

  echo_yellow "Installing trackpoint config"
  # Adapted from https://baach.de/Members/jhb/fixing-the-trackpoint-on-ubuntu
  sudo apt-get install xserver-xorg-input-synaptics-hwe-18.04 xserver-xorg-input-evdev-hwe-18.04
  sudo apt-get remove xserver-xorg-input-libinput xserver-xorg-input-libinput-hwe-18.04
  cp $ROOT_DIR/config/20-thinkpad.conf /usr/share/X11/xorg.conf.d/20-thinkpad.conf
  TRACKPOINT_NAME="$(xinput --list --name-only | grep TrackPoint)"
  echo "xinput set-prop ${TRACKPOINT_NAME} 297 0.75" > ~/.xinitrc
  echo_yellow "Reboot to apply changes"
}

uninstall_trackpoint_config(){
  read -p "Do you really want to remove the trackpoint config [y/n]? " -n 1 -r
  echo
  if [ ! "$REPLY" = Y ] && [ ! "$REPLY" = y ]; then
    echo_red "Exiting." && exit 0
  else
    echo_yellow "Removing trackpoint config"
    sudo apt-get install xserver-xorg-input-libinput xserver-xorg-input-libinput-hwe-18.04
    sudo apt-get remove xserver-xorg-input-synaptics-hwe-18.04 xserver-xorg-input-evdev-hwe-18.04
    rm -rf /usr/share/X11/xorg.conf.d/20-thinkpad.conf
    rm -rf ~/.xinitrc
  fi
}
