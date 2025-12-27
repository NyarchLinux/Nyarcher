#!/bin/bash

LATEST_TAG_VERSION=`curl -s https://api.github.com/repos/NyarchLinux/NyarchLinux/releases/latest | grep "tag_name" | awk -F'"' '/tag_name/ {print $4}'`
RELEASE_LINK="github.com/NyarchLinux/NyarchLinux/releases/latest/download/"

RED='\033[0;31m'
NC='\033[0m'

curl https://raw.githubusercontent.com/NyarchLinux/NyarchLinux/main/Gnome/etc/skel/.config/neofetch/ascii70
echo -e "$RED\n\nWelcome to Nyarch Linux customization installer! $NC"


check_gnome_version() {
  GNOME_VERSION=`gnome-session --version`
  GNOME_VERSION_NUMBER=${GNOME_VERSION##* }
  GNOME_VERSION_MAJOR=${GNOME_VERSION_NUMBER%%.*}
  if [ "$GNOME_VERSION_MAJOR" -lt 47 ]; then
    echo "You need Gnome version 47 or above."
    exit
  fi
}

check_gnome_is_running() {
  CURRENT_ENV=${XDG_CURRENT_DESKTOP,,}
  if [[ $CURRENT_ENV != *"gnome"* ]]; then
    echo "Gnome isn't running, please launch gnome environment first"
    exit
  fi
}

get_tarball() {
    file_path=/tmp/NyarchLinux.tar.gz
    url=${RELEASE_LINK}NyarchLinux.tar.gz

    echo "Downloading Nyarch tarball from $url"
    wget -q -O "$file_path" "$url"
    cd /tmp
    tar -xf "$file_path"
}

install_extensions () {
  cd ~/.local/share/gnome-shell  # Go to Gnome extensions config folder 
  echo "Backup old extensions to extensions-backup..."
  mv -f extensions extensions-backup  # Backup old extensions 

  cp -rf /tmp/NyarchLinuxComp/Gnome/etc/skel/.local/share/gnome-shell/extensions ~/.local/share/gnome-shell
  
  # Install material you
  cd /tmp
  git clone https://github.com/FrancescoCaracciolo/material-you-colors.git
  cd material-you-colors
  make build
  make install
  npm install --prefix $HOME/.local/share/gnome-shell/extensions/material-you-colors@francescocaracciolo.github.io;
  cd $HOME/.local/share/gnome-shell/extensions/material-you-colors@francescocaracciolo.github.io
  git clone https://github.com/francescocaracciolo/adwaita-material-you
  cd adwaita-material-you
  bash local-install.sh
  # Set correct permissions 
  cd
  chmod -R 755 $HOME/.local/share/gnome-shell/extensions/*
  
  # Install material you icons 
  cp -rf /tmp/NyarchLinuxComp/Gnome/etc/skel/.config/nyarch ~/.config
  cd ~/.config/nyarch
  git clone https://github.com/vinceliuice/Tela-circle-icon-theme
}

install_nyaofetch() {
  cd /usr/bin # Install nekofetch and nyaofetch
  # Download scripts
  sudo cp -rf /tmp/NyarchLinuxComp/Gnome/usr/local/bin/nekofetch .
  sudo cp -rf /tmp/NyarchLinuxComp/Gnome/usr/local/bin/nyaofetch .
  # Give the user execution permissions
  sudo chmod +x nekofetch
  sudo chmod +x nyaofetch
}

configure_neofetch() {
  mv ~/.config/fastfetch ~/.config/fastfetch-backup  # Backup previous fastfetch
  # Install new fastfetch files
  cp -rf /tmp/NyarchLinuxComp/Gnome/etc/skel/.config/fastfetch ~/.config
}

download_wallpapers() {
  # download and install latest wallpaper
  cd /tmp
  wget ${RELEASE_LINK}wallpaper.tar.gz
  tar -xvf wallpaper.tar.gz
  bash install.sh

  # installs the rest
  cd $HOME/.local/share/
  cp -rf /tmp/NyarchLinuxComp/Gnome/etc/skel/.local/share/backgrounds .

}

# TODO CONTINUE
download_icons() {
  cd /tmp 
  wget ${RELEASE_LINK}icons.tar.gz
  tar -xvf icons.tar.gz
  cp -rf Tela-circle-MaterialYou-6d3900 ~/.local/share/icons/ #you may want to update the number (Tela-circle-MaterialYou-6d3900)
}

set_themes() {
  cd ~/.local/share
  mv themes themes-backup  # Backup icons
  cp -rf /tmp/NyarchLinuxComp/Gnome/etc/skel/.local/share/themes ~/.local/share
  cd ~/.config
  # Set GTK4 and GTK3 themes
  mv gtk-3.0 gtk-3.0-backup
  mv gtk-4.0 gtk-4.0-backup
  cp -rf /tmp/NyarchLinuxComp/Gnome/etc/skel/.config/gtk-3.0 ~/.config
  cp -rf /tmp/NyarchLinuxComp/Gnome/etc/skel/.config/gtk-4.0 ~/.config
}

configure_kitty (){
  cd ~/.config/
  mv ~/.config/kitty/kitty.conf kitty-backup.conf
  cp -rf /tmp/NyarchLinuxComp/Gnome/etc/skel/.config/kitty/ .
}

flatpak_overrides() {
  sudo flatpak override --filesystem=xdg-config/gtk-3.0
  sudo flatpak override --filesystem=xdg-config/gtk-4.0
}

install_flatpaks() {
  flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  flatpak install org.gtk.Gtk3theme.adw-gtk3 org.gtk.Gtk3theme.adw-gtk3-dark
  # Install latest release of everything
  cd /tmp/NyarchLinuxComp/Gnome/
  sh install_flatpaks.sh
}

install_nyarch_updater() {
  # Install Nyarch Updater
  cd /tmp
  wget https://github.com/nyarchlinux/nyarchupdater/releases/latest/download/nyarchupdater.flatpak
  flatpak install nyarchupdater.flatpak
  sudo bash -c 'echo 241104 > /version'
}

configure_gsettings() {
  dconf dump / > ~/dconf-backup.txt  # Save old gnome settings
  cd /tmp/NyarchLinuxComp/Gnome/etc/dconf/db/local.d
  # Load settings
  dconf load / < 06-extensions  # Load extensions settings
  dconf load / < 02-interface  # Load theme settings
  dconf load / < 04-wmpreferences  # Add minimize button
  dconf load / < 03-background  # Set gnome terminal and background settings
}

add_pywal() {
  echo 'if [[ -f "$HOME/.cache/wal/sequences" ]]; then' >> ~/.bashrc
  echo '    (cat $HOME/.cache/wal/sequences)' >> ~/.bashrc
  echo 'fi' >> ~/.bashrc
}


## EXECUTION PART

check_gnome_version
check_gnome_is_running

read -r -p "Have you installed all the dependecies listed in the github page of this script? (Y/n): " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
  echo Cool! We can go ahead
  get_tarball
else
  echo You need to have already installed the dependencies listed on github before running this script!
  exit
fi

read -r -p "Do you want to install our Gnome extensions, they are important for the overall desktop customization? (Y/n): " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
  install_extensions
  echo "Gnome extensions installed!"
fi
read -r -p "[SYSTEM] Do you want to install Nekofetch and Nyaofetch and configure neofetch, to tell everyone that you use nyarch btw? (Y/n): " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
  install_nyaofetch
  configure_neofetch
  echo "Nyaofetch and Neofetch installed!"
fi
read -r -p "Download Nyarch wallpapers? (Y/n): " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
  download_wallpapers
  echo "Wallpapers downloaded!"
fi
read -r -p "Do you want to download our icons? (Y/n): " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
  download_icons
  echo "Icons downloaded!"
fi
read -r -p "Do you want to download our themes? (Y/n): " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
  set_themes
  echo "Themes downloaded!"
fi
read -r -p "Do you want to apply our customizations to kitty terminal? (Y/n): " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
  configure_kitty
  echo "Kitty configured!"
fi
read -r -p "Do you want to add pywal theming to your ~/.bashrc (for other shells you have to do it manually)? (Y/n): " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
  add_pywal
  echo "pywal configured!"
fi
read -r -p "Do you want to apply your GTK themes to flatpak apps? (Y/n): " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
  flatpak_overrides
  echo "Flatpak themes configured!"
fi
read -r -p "Do you want to install suggested flatpaks to enhance your weebflow (includes Nyarch Exclusive applications)? (Y/n): " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
  install_flatpaks
  echo "Suggested apps installed!"
fi
read -r -p "[SYSTEM] Do you want to install Nyarch Updater? It's going to have some issues outside of Nyarch and Arch in general (Y/n): " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
  install_nyarch_updater
  echo "Nyarch Updater installed!"
fi

read -r -p "Do you want to edit your Gnome settings? Note that if you have not installed something before, you may experience some bugs at the start (Y/n): " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
  configure_gsettings
  echo "Gnome settings updated"
fi



echo -e "$RED Log out and login to see the results! $NC"


