describe_dropbox(){
  echo "Dropbox daemon."
}

install_dropbox(){
  if [ ! "$OS" = "linux" ]; then
    echo_red "installing dropbox is currently only implemented for linux" && return 1
  fi

  EXCLUDED_DROPBOX_DIRS=("$HOME/Dropbox/archive"
                         "$HOME/Dropbox/data"
                         "$HOME/Dropbox/photos"
                         "$HOME/Dropbox/private"
                         "$HOME/Dropbox/Kamera-Uploads"
                         "$HOME/Dropbox/Camera-Uploads")

  cd ~ && echo_yellow "Installing dropbox"
  wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
  sudo wget -O /usr/local/bin/dropbox "https://www.dropbox.com/download?dl=packages/dropbox.py"
  sudo chmod +x /usr/local/bin/dropbox
  echo fs.inotify.max_user_watches=100000 | sudo tee -a /etc/sysctl.conf; sudo sysctl -p
  dropbox start
  dropbox autostart y && dropbox exclude add $EXCLUDED_DROPBOX_DIRS
  mkdir ~/.config/autostart && cat <<EOF > ~/.config/autostart/dropbox.desktop
[Desktop Entry]
Type=Application
Name=Dropbox
Exec=dropbox start
EOF
}

uninstall_dropbox(){
  read -p "Do you really want to uninstall dropbox [y/n]? " -n 1 -r
  echo
  if [ ! "$REPLY" = Y ] && [ ! "$REPLY" = y ]; then
    echo_red "Exiting." && exit 1
  else
    echo_yellow "Uninstalling dropbox"
    dropbox stop
    dropbox status  # Should report "not running"
    rm -rf ~/.dropbox-dist
    rm -rf /var/lib/dropbox
    rm -rf ~/.dropbox*
    sudo apt-get remove nautilus-dropbox
    sudo apt-get remove dropbox
    rm /etc/apt/source.d/dropbox
    echo "done."
  fi
}
