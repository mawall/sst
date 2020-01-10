install_dropbox(){
  check_if_linux && if [ ! "$OS" = "linux" ]; then
    echo_red "nvtop installation is currently only implemented for linux" && return 1
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
  dropbox start
  dropbox autostart y && dropbox exclude add $EXCLUDED_DROPBOX_DIRS
  mkdir ~/.config/autostart && cat <<EOF > ~/.config/autostart/dropbox.desktop
[Desktop Entry]
Type=Application
Name=Dropbox
Exec=dropbox start
EOF
}