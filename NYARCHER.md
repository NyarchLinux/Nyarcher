# This file explains how nyarcher.sh works

## Requirements
To run, the script assumes you have ha pretty much vanilla Gnome installation, and these packages installed:
- Kitty
- wget
- git
- neofetch

## Install Nyarch applications
```bash
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
```
## Install neofetch configuration
### Install nyaofetch and nekofetch
```bash

```
### Install neofetch config files
```bash
rm -rf ~/.config/neofetch
mkdir -p ~/.config/neofetch

```
