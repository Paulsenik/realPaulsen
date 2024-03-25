#!/bin/bash

# Paulsenik's Ubuntu/Debian Installscript # (run on plain Debian can be buggy)
# Normally used for KDE (Kubuntu, KDE-Neon, etc.)
# Installs my main programms with minimal configs
#
# https://paulsenik.de
# mail@paulsenik.de


# Variables:
## Colors
Color_Off='\033[0m'
BPurple='\033[1;35m'
BBlue='\033[1;34m'
## other
folderPictures="${HOME}/Pictures"
folderDocuments="${HOME}/Documents"
folderInstalls="${HOME}/Installs"
folderCode="${HOME}/Dev"
folderRepo="$folderInstalls/paulsenik"
## programms
Toolbox="jetbrains-toolbox-2.2.3.20090"
KrohnkiteV="0.8.1"
Link_Toolbox="https://download.jetbrains.com/toolbox/${Toolbox}.tar.gz" #--version: https://www.jetbrains.com/toolbox-app/download/other.html
Link_Krohnkite="https://github.com/esjeon/krohnkite/releases/download/v${KrohnkiteV}/krohnkite-${KrohnkiteV}.kwinscript"
Link_Ulauncher="https://github.com/Ulauncher/Ulauncher/releases/download/5.15.6/ulauncher_5.15.6_all.deb"
Proton_Bridge="https://proton.me/download/bridge/protonmail-bridge_3.10.0-1_amd64.deb"
Proton_VPN="https://repo.protonvpn.com/debian/dists/stable/main/binary-all/protonvpn-stable-release_1.0.3-2_all.deb"


# Start
echo -e "\n${BPurple}*----<[ Start setup ]>----*${Color_Off}\n"
## Setup
mkdir -p $folderDocuments
mkdir -p $folderPictures
mkdir -p $folderInstalls
mkdir -p $folderCode


# Updating
echo -e "\n\n${BPurple}> Updating.. <  ${Color_Off}\n"

echo "Proceed? [y/N]: "
read confirm
if [[ $confirm == y* ]]; then
  sudo apt update -y
else
  echo "Skipping..."
fi


# Discover
echo -e "\n\n${BPurple}> Setting up Discover.. < ${Color_Off}\n"
#-

echo "Proceed? [y/N]: "
read confirm
if [[ $confirm == y* ]]; then
  sudo apt install discover -y
  sudo apt install flatpak -y
  sudo apt install plasma-discover-backend-flatpak -y
  flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
else
  echo "Skipping..."
fi


## apt
echo -e "\n\n${BPurple}> Applications & Packages < ${Color_Off}\n"
echo -e "${BBlue}>> APT-Packages << ${Color_Off}\n"
echo "Proceed? [y/N]: "
read confirm
if [[ $confirm == y* ]]; then

  ### jetbrains toolbox-app dependencies
  sudo apt install libfuse2 libxi6 libxrender1 libxtst6 mesa-utils libfontconfig libgtk-3-bin -y

  ### Yubikey
  sudo apt install libpam-yubico libpam-u2f ykls yubikey-luks yubikey-manager yubikey-personalization scdaemon -y

  ### apt
  sudo apt install kdeconnect -y
  sudo apt install default-jre default-jdk -y
  sudo apt install python3-pip -y # Ulauncher dependency
  sudo apt install wmctrl -y #-- Ulauncher-toggle option

else
  echo "Skipping..."
fi


## flatpak
echo -e "\n\n${BBlue}>> Flatpak << ${Color_Off}\n"
##-
echo "Proceed? [y/N]: "
read confirm
if [[ $confirm == y* ]]; then

  flatpak install com.github.Eloston.UngoogledChromium -y --noninteractive
  flatpak install com.discordapp.Discord -y --noninteractive
  flatpak install com.github.tchx84.Flatseal -y --noninteractive
  flatpak install com.nextcloud.desktopclient.nextcloud -y --noninteractive
  flatpak install com.spotify.Client -y --noninteractive
  flatpak install com.teamspeak.TeamSpeak -y --noninteractive
  flatpak install im.riot.Riot -y --noninteractive
  flatpak install md.obsidian.Obsidian -y --noninteractive
  flatpak install org.flameshot.Flameshot -y --noninteractive
  flatpak install org.kde.filelight -y --noninteractive
  flatpak install org.kde.kcalc -y --noninteractive
  flatpak install org.kde.kcolorchooser -y --noninteractive
  flatpak install org.kde.krita -y --noninteractive
  flatpak install org.mozilla.Thunderbird -y --noninteractive
  flatpak install org.onlyoffice.desktopeditors -y --noninteractive
  flatpak install org.telegram.desktop -y --noninteractive

else
  echo "Skipping..."
fi


## VPN
echo -e "${BBlue}>> VPNs & Mail << ${Color_Off}\n"
echo "Proceed? [y/N]: "
read confirm
if [[ $confirm == y* ]]; then

  cd $folderInstalls

  ### Netbird dependecy
  sudo apt install ca-certificates curl gnupg -y
  curl -sSL https://pkgs.netbird.io/debian/public.key | sudo gpg --dearmor --output /usr/share/keyrings/netbird-archive-keyring.gpg
  echo 'deb [signed-by=/usr/share/keyrings/netbird-archive-keyring.gpg] https://pkgs.netbird.io/debian stable main' | sudo tee /etc/apt/sources.list.d/netbird.list
  ### Nebird UI & CLI
  sudo apt-get update -y
  sudo apt-get install netbird -y
  sudo apt-get install netbird-ui -y

  ### Proton
  #### Mail
  wget -nv -nc --show-progress --progress="bar" $Proton_Bridge
  sudo apt install ./protonmail-bridge_3.10.0-1_amd64.deb -y

  #### VPN
  wget -nv -nc --show-progress --progress="bar" $Proton_VPN
  sudo dpkg -i ./protonvpn-stable-release_1.0.3-2_all.deb -y
  sudo apt update -y

else
  echo "Skipping..."
fi


## Manual Download
echo -e "\n\n${BBlue}>> Other << ${Color_Off}\n"
cd $folderInstalls

echo "Proceed? [y/N]: "
read confirm
if [[ $confirm == y* ]]; then

  ### Ulauncher
  wget -nv -nc --show-progress --progress="bar" $Link_Ulauncher
  sudo apt install ./ulauncher_5.15.6_all.deb -y
  pip3 install requests --user #-- pip-Dependencies

  ### Jetbrains-Toolbox
  wget -nv -nc --show-progress --progress="bar" $Link_Toolbox
  tar -xf ${Toolbox}.tar.gz
  cd $Toolbox
  ./jetbrains-toolbox --minimize

else
  echo "Skipping..."
fi


# Config & Files
echo -e "\n\n${BPurple}> Configs < ${Color_Off}\n"

echo "Proceed? [y/N]: "
read confirm
if [[ $confirm == y* ]]; then

  ## Repo-Files
  cd $folderInstalls
  rm -rf paulsenik
  git clone https://github.com/paulsenik/paulsenik.git

  ## Ulauncher
  cp -r -u ${folderRepo}/.config/ulauncher ${HOME}/.config
  ## Ryolith
  cp -r -u ${folderRepo}/.ryolith ${HOME}
  ## Inputsink
  cp -r -u ${folderRepo}/.inputsink ${HOME}
  ## Konsole
  cp -r -u ${folderRepo}/.local/share/konsole/ ${HOME}/.local/share/

  ## Desktop-Links
  cp -r -u ${folderRepo}/.local/share/applications/ ${HOME}/.local/share/
  ##- change Desktop-Links (https://askubuntu.com/questions/20414/find-and-replace-text-within-a-file-using-commands)
  ##- Replaces _HOME_ with actual home-folder
  sed -i "s/_HOME_/\/home\/${USER}/g" ${HOME}/.local/share/applications/*

else
  echo "Skipping..."
fi


## KDE (check if kde5)
if command -v kwriteconfig5 >/dev/null 2>&1; then
  echo -e "\n\n${BPurple}Setting kde5-configs: ${Color_Off}\n"
  echo -e "${BBlue}import ${BPurple}kde-shortcuts.kksrc ${BBlue}into Settings/Shortcuts.${Color_Off}"

  echo "Proceed? [y/N]: "
  read confirm
  if [[ $confirm == y* ]]; then

    ### Background
    kwriteconfig5 --file "$HOME/.config/plasma-org.kde.plasma.desktop-appletsrc" --group 'Containments' --group '1' --group 'Wallpaper' --group 'org.kde.image' --group 'General' --key 'Image' "$folderInstalls/paulsenik/Pictures/Profile/Phoenix 1.0/phoenix_v1.0_UHD-2.png"

    ### Krohnkite
    cd $folderInstalls
    wget -nv -nc --show-progress --progress="bar" $Link_Krohnkite
    plasmapkg2 -t kwinscript -i "krohnkite-${KrohnkiteV}.kwinscript"
    ###- Enable User Config
    mkdir -p "$HOME/.local/share/kservices5/"
    ln -s "$HOME/.local/share/kwin/scripts/krohnkite/metadata.desktop" "$HOME/.local/share/kservices5/krohnkite.desktop"

  else
    echo "Skipping..."
  fi
else
  echo "${BBlue}No kde5-installation found!"
fi


exit