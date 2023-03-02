# Nyarcher
Nyarcher is a Shell script to install [Nyarch Linux](https://github.com/NyarchLinux/NyarchLinux) customizations on many Linux Distributions

## Disclaimer
The script aims to give the most similar experience to Nyarch Linux on any Linux distribution, without editing system files. For there reasons, gnome terminal settings are not edited, and plymouth (for boot splashscreen) is not installed.
Also, some applications, specially Nyarch Scripts, might not work correctly in non arch based distributions.
## Install pre-requirements
**On any distribution, a working installation of Gnome 43 is needed**

### Arch-based distributions
```bash
sudo pacman -S flatpak svn gnome-menus kitty wget git neofetch npm nodejs btop gnome-menus gnome-shell-extensions
```
It is also suggested to install `webapp-manager` and `gnome-terminal-transparency` from the AUR.

### Fedora based distributions
```bash
sudo dnf install flatpak svn gnome-menus kitty wget git neofetch npm nodejs btop gnome-menus gnome-extensions-app
```
### Ubuntu based distributions
```bash
sudo apt install flatpak subversion gnome-menus kitty wget git neofetch npm nodejs btop gnome-menus gnome-shell-extension-prefs
```
## Running the script 
If you want to learn what the script does, you can read [NYARCHER.md](https://github.com/NyarchLinux/Nyarcher/blob/main/NYARCHER.md) file.
<br />
**NOTE: The script back-ups most of the existing configuration before overwriting them, also, excluding /usr/bin/nyaofetch and /usr/bin/nekofetch files, it only edits settings for the current user**
<br />
Download `nyarcher.sh` and add the permission of execution, then execute it
```bash
git clone https://github.com/NyarchLinux/Nyarcher.git
cd Nyarcher
chmod +x nyarcher.sh
./nyarcher.sh
```
The script will ask you if you want to apply some settings, it is **strongly suggested to say yes to everything** in order to have a stable experience.
