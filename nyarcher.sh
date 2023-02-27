#!/bin/sh
RED='\033[0;31m'
NC='\033[0m'

curl https://raw.githubusercontent.com/NyarchLinux/NyarchLinux/main/Gnome/etc/skel/.config/neofetch/ascii70
echo -e "$RED\n\nWelcome to Nyarch Linux installer! $NC"

install_extensions () {
  cd ~/.local/share/gnome-shell  # Go to Gnome extensions config folder 
  mv extensions extensions-backup  # Backup old extensions 
  # Download current extensions from main branch
  svn checkout https://github.com/NyarchLinux/NyarchLinux/trunk/Gnome/etc/skel/.local/share/gnome-shell/extensions
  # Set correct permissions
  chmod -R 755 *
}
install_nyaofetch() {
  cd /usr/bin # Install nekofetch and nyaofetch
  # Download scripts
  sudo wget https://raw.githubusercontent.com/NyarchLinux/NyarchLinux/main/Gnome/usr/local/bin/nekofetch
  sudo wget https://raw.githubusercontent.com/NyarchLinux/NyarchLinux/main/Gnome/usr/local/bin/nyaofetch
  # Give the user execution permissions
  sudo chmod +x nekofetch
  sudo chmod +x nyaofetch

}

configure_neofetch() {
  mv ~/.config/neofetch ~/.config/neofetch-backup  # Backup previous neofetch
  # Install new neofetch files
  cd ~/.config
  svn checkout https://github.com/NyarchLinux/NyarchLinux/trunk/Gnome/etc/skel/.config/neofetch
}

download_wallpapers() {
  cd /tmp
  svn checkout https://github.com/NyarchLinux/NyarchLinux/trunk/Gnome/etc/skel/.local/share/backgrounds
  mkdir -p ~/.local/share/backgrounds/
  mv backgrounds/* ~/.local/share/backgrounds/
  chmod -R 777 ~/.local/share/backgrounds
}

download_icons() {
  cd ~/.local/share
  mv icons icons-backup  # Backup icons
  svn checkout https://github.com/NyarchLinux/NyarchLinux/trunk/Gnome/etc/skel/.local/share/icons
}

set_themes() {
  cd ~/.local/share
  mv themes themes-backup  # Backup icons
  svn checkout https://github.com/NyarchLinux/NyarchLinux/trunk/Gnome/etc/skel/.local/share/themes
  cd ~/.config
  # Set GTK4 and GTK3 themes
  mv gtk-3.0 gtk-3.0-backup
  mv gtk-4.0 gtk-4.0-backup
  svn checkout https://github.com/NyarchLinux/NyarchLinux/trunk/Gnome/etc/skel/.config/gtk-3.0
  svn checkout https://github.com/NyarchLinux/NyarchLinux/trunk/Gnome/etc/skel/.config/gtk-4.0
}

configure_kitty (){
  mkdir ~/.config/kitty
  cd ~/.config/kitty
  mv kitty.conf kitty-backup.conf
  wget https://raw.githubusercontent.com/NyarchLinux/NyarchLinux/main/Gnome/etc/skel/.config/kitty/kitty.conf
}


flatpak_overrides() {
  sudo flatpak override --filesystem=xdg-config/gtk-3.0
  sudo flatpak override --filesystem=xdg-config/gtk-4.0
}


install_flatpaks() {
  flatpak install org.gtk.Gtk3theme.adw-gtk3 org.gtk.Gtk3theme.adw-gtk3-dark
  # Komikku
  flatpak install flathub info.febvre.Komikku
  # Flatseal
  flatpak install flathub com.github.tchx84.Flatseal
  # Shortwave
  flatpak install flathub de.haeckerfelix.Shortwave
  # Lollypop
  flatpak install flathub org.gnome.Lollypop
  # Fragments
  flatpak install flathub de.haeckerfelix.Fragments
  # Flatseal
  flatpak install flathub com.github.tchx84.Flatseal
  # Extension Manager
  flatpak install flathub com.mattjakeman.ExtensionManager
}

install_nyarch_apps() {
  # Install latest release of CatgirlDownloader through flatpak bundle
  cd /tmp
  wget https://github.com/nyarchlinux/catgirldownloader/releases/latest/download/catgirldownloader.flatpak 
  flatpak install catgirldownloader.flatpak

  # Install latest release of NyarchWizard through flatpak bundle
  cd /tmp
  wget https://github.com/nyarchlinux/nyarchwizard/releases/latest/download/nyarchwizard.flatpak 
  flatpak install wizard.flatpak

  # Install latest release of NyarchTour through flatpak bundle
  cd /tmp
  wget https://github.com/nyarchlinux/nyarchtour/releases/latest/download/nyarchtour.flatpak 
  flatpak install nyarchtour.flatpak

  # Install latest release of NyarchCustomize
  cd /tmp
  wget https://github.com/nyarchlinux/nyarchcustomize/releases/latest/download/nyarchcustomize.flatpak 
  flatpak install nyarchcustomize.flatpak
 
  # Install Nyarch Scripts
  cd /tmp
  wget https://github.com/nyarchlinux/nyarchscript/releases/latest/download/nyarchscript.flatpak
  flatpak install nyarchscript.flatpak
  
}

configure_gsettings() {
  dconf dump / > ~/dconf-backup.txt  # Save old gnome settings
  cd /tmp
  # Download default settings
  svn checkout https://github.com/NyarchLinux/NyarchLinux/trunk/Gnome/etc/dconf/db/local.d
  cd local.d
  # Load settings
  dconf load / < 06-extensions  # Load extensions settings
  dconf load / < 02-interface  # Load theme settings
  dconf load / < 04-wmpreferences  # Add minimize button
  dconf load / < 03-background  # Set gnome terminal and background settings
  # Fix wallpaper settings
  gsettings set org.gnome.desktop.background picture-uri "$HOME/.local/share/backgrounds/default.png"
  gsettings set org.gnome.desktop.background picture-uri-dark "$HOME/.local/share/backgrounds/default.png"
}

read -r -p "Are you running this script on a system running Gnome Desktop Environment? (Y/n): " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
  echo Cool! We can go ahead
else
  echo You need to have already Gnome installed and running to run this script!
  exit
fi

read -r -p "Have you installed all the dependecies listed in the github page of this script? (Y/n): " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
  echo Cool! We can go ahead
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
read -r -p "Do you want to install Nekofetch and Nyaofetch and configure neofetch, to tell everyone that you use nyarch btw? (Y/n): " response
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
read -r -p "Do you want to apply your GTK themes to faltpak apps? (Y/n): " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
  flatpak_overrides
  echo "Flatpak themes configured!"
fi
read -r -p "Do you want to install suggested flatpaks to enhance your weebflow (You will be able to not download only some of them)? (Y/n): " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
  install_flatpaks
  echo "Suggested apps installed!"
fi
read -r -p "Do you want to install Nyarch Exclusive applications? (Y/n): " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
  install_nyarch_apps
  echo "Nyarch apps installed!"
fi
read -r -p "Do you want to edit your Gnome settings? Note that if you have not installed something before, you may experience some bugs at the start (Y/n): " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
  configure_gsettings
  echo "Nyarch apps installed!"
fi

echo -e "$RED Log out and login to see the results! $NC"


