#!/bin/bash

# Check if Script is Run as Root
if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user to run this script, please run sudo ./install.sh" 2>&1
  exit 1
fi

username=$(id -u -n 1000)
builddir=$(pwd)

# Update packages list and update system
apt update
apt upgrade -y

# Install nala
apt install nala -y


# Making .config and Moving config files and background to Pictures
cd "$builddir" || exit
mkdir -p "/home/$username/.config"
mkdir -p "/home/$username/.fonts"
mkdir -p "/home/$username/Pictures"
mkdir -p "/home/$username/.config/leftwm/themes"

mkdir -p /usr/share/sddm/themes

cp -R "$builddir/config/"* "/home/$username/.config/"
chown -R "$username:$username" "/home/$username"

cd "/home/$username/.config/leftwm/themes/" || exit
ln -s basic_polybar current

# Installing sugar-candy dependencies
nala install libqt5svg5 qml-module-qtquick-controls qml-module-qtquick-controls2 -y
# Installing Essential Programs 
nala install feh rofi polybar picom thunar lxpolkit x11-xserver-utils unzip yad wget pulseaudio pavucontrol -y
# Installing Other less important Programs
nala install neofetch curl flameshot psmisc mangohud vim lxappearance papirus-icon-theme lxsession lxappearance fonts-noto-color-emoji sddm variety -y

echo "installing rust"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source "home/$username/.profile" || exit
echo "install leftwm"
cargo install leftwm

sudo cp "$builddir/leftwm.desktop" /usr/share/xsessions

# Download Nordic Theme
cd /usr/share/themes/ || exit
git clone https://github.com/EliverLara/Nordic.git

# Installing fonts
cd $builddir || exit
nala install fonts-font-awesome
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip
unzip FiraCode.zip -d /home/$username/.fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Meslo.zip
unzip Meslo.zip -d /home/$username/.fonts
mv dotfonts/fontawesome/otfs/*.otf /home/$username/.fonts/
chown $username:$username /home/$username/.fonts/*

# Reloading Font
fc-cache -vf
# Removing zip Files
rm ./FiraCode.zip ./Meslo.zip

# Install Nordzy cursor
git clone https://github.com/alvatip/Nordzy-cursors
cd Nordzy-cursors || exit
./install.sh
cd $builddir || exit
rm -rf Nordzy-cursors

# Install brave-browser
# sudo nala install apt-transport-https curl -y
# sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
# echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
# sudo nala update
# sudo nala install brave-browser -y

# Enable graphical login and change target from CLI to GUI
systemctl enable sddm
systemctl set-default graphical.target
