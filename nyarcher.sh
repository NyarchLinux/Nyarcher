#!/bin/sh

install_extensions () {
  cd ~/.local/share/gnome-shell  # Go to Gnome extensions config folder 
  mv extensions extensions-backup  # Backup old extensions 
  # Download current extensions from main branch
  svn checkout https://github.com/NyarchLinux/NyarchLinux/trunk/Gnome/etc/skel/.local/share/gnome-shell/extensions
  # Set correct permissions
  chmod -R 755 *
}

install_nyaofetch() {
  cd ~/.local/bin  # Install nekofetch and nyaofetch only for current user
  # Download scripts
  wget https://raw.githubusercontent.com/NyarchLinux/NyarchLinux/main/Gnome/usr/local/bin/nekofetch
  wget https://raw.githubusercontent.com/NyarchLinux/NyarchLinux/main/Gnome/usr/local/bin/nyaofetch
  # Give the user execution permissions
  chmod +x nekofetch
  chmod +x nyaofetch
}

configure_neofetch {
  mv ~/.config/neofetch ~/.config/neofetch-backup  # Backup previous neofetch
  # Install new neofetch files
  cd ~/.config
  svn checkout https://github.com/NyarchLinux/NyarchLinux/trunk/Gnome/etc/skel/.config/neofetch
}

download_wallpapers() {
  cd /tmp
  svn checkout https://github.com/NyarchLinux/NyarchLinux/trunk/Gnome/etc/skel/.local/share/backgrounds
  mv backgrounds/* ~/.local/share/backgrounds/
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
}

install_nyarch_apps() {
  # Install latest release of CatgirlDownloader through flatpak bundle
  cd /tmp
  wget https://github.com/nyarchlinux/catgirldownloader/releases/latest/download/catgirldownloader.flatpak 
  flatpak install catgirldownloader.flatpak

  # Install latest release of NyarchWizard through flatpak bundle
  cd /tmp
  wget https://github.com/nyarchlinux/nyarchwizard/releases/latest/download/nyarchwizard.flatpak 
  flatpak install nyarchwizard.flatpak

  # Install latest release of NyarchTour through flatpak bundle
  cd /tmp
  wget https://github.com/nyarchlinux/nyarchtour/releases/latest/download/nyarchtour.flatpak 
  flatpak install nyarchtour.flatpak

  # Install latest release of NyarchCustomize
  cd /tmp
  wget https://github.com/nyarchlinux/nyarchcustomize/releases/latest/download/nyarchcustomize.flatpak 
  flatpak install nyarchcustomize.flatpak
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
  gsettings set org/gnome/desktop/background picture-uri "$HOME/.local/share/backgrounds/default.png"
  gsettings set org/gnome/desktop/background picture-uri-dark "$HOME/.local/share/backgrounds/default.png"
}

