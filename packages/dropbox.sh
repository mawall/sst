describe_dropbox(){
  echo "Dropbox daemon."
}

listcmd_dropbox(){
  echo "dropbox"
}

install_dropbox(){
  install_dropbox_"$OS"
}

install_dropbox_linux(){
  EXCLUDED_DROPBOX_DIRS=("${HOME}/Dropbox/archive"
                         "${HOME}/Dropbox/data"
                         "${HOME}/Dropbox/Kamera-Uploads"
                         "${HOME}/Dropbox/Camera-Uploads"
                         "${HOME}/Dropbox/movies"
                         "${HOME}/Dropbox/music"
                         "${HOME}/Dropbox/photos"
                         "${HOME}/Dropbox/private"
                         "${HOME}/Dropbox/public"
                         "${HOME}/Dropbox/software")

  cd ~ && echo_yellow "Installing dropbox"
  wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
  sudo wget -O /usr/local/bin/dropbox "https://www.dropbox.com/download?dl=packages/dropbox.py"
  sudo chmod +x /usr/local/bin/dropbox
  echo fs.inotify.max_user_watches=100000 | sudo tee -a /etc/sysctl.conf; sudo sysctl -p
  nohup dropbox start &
  sleep 40  # Wait until dropbox has started to sync, otherwise exclude will fail
  dropbox autostart y && dropbox exclude add "${EXCLUDED_DROPBOX_DIRS[@]}"
  mkdir ~/.config/autostart
  cat <<EOF > ~/.config/autostart/dropbox.desktop
[Desktop Entry]
Type=Application
Name=Dropbox
Exec=dropbox start
EOF
  echo_yellow "Successfully installed dropbox"
}

install_dropbox_mac_os(){
  echo_yellow "Installing dropbox"
  brew install --cask dropbox
  echo_yellow "Successfully installed dropbox"
}

uninstall_dropbox(){
  uninstall_dropbox_"$OS"
}

uninstall_dropbox_linux(){
  read -p "Do you really want to uninstall dropbox [y/n]? " -n 1 -r
  echo
  if [ ! "$REPLY" = Y ] && [ ! "$REPLY" = y ]; then
    echo_red "Exiting." && exit 0
  else
    echo_yellow "Uninstalling dropbox"
    dropbox stop
    rm -rf ~/.dropbox-dist
    rm -rf /var/lib/dropbox
    rm -rf ~/.dropbox*
    sudo apt-get remove nautilus-dropbox
    sudo apt-get remove dropbox
    rm /etc/apt/source.d/dropbox
    rm ~/.config/autostart/dropbox.desktop
    echo "done."
  fi
}

uninstall_dropbox_mac_os(){
  read -p "Do you really want to uninstall dropbox [y/n]? " -n 1 -r
  echo
  if [ ! "$REPLY" = Y ] && [ ! "$REPLY" = y ]; then
    echo_red "Exiting." && exit 0
  else
    echo_yellow "Uninstalling dropbox"
    brew uninstall dropbox
    echo "done."~/.config/autostart/dropbox.desktop
  fi
}
