#!/bin/bash

sudo apt update && sudo apt -y upgrade

# Large bundle of packages
sudo apt -y install \
    neofetch \
    neovim \
    zsh \
    zsh-autosuggestions \
    zsh-syntax-highlighting \
    ttf-mscorefonts-installer \
    ttf-bitstream-vera \
    ttf-dejavu \
    qbittorrent \
    cmake \
    gtk2-engines-murrine \
    gtk2-engines-pixbuf \
    cowsay \
    figlet \
    fortune


# Alacritty
sudo add-apt-repository ppa:mmstick76/alacritty
sudo apt install alacritty

# dotnet
wget https://packages.microsoft.com/config/ubuntu/21.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb
sudo apt-get update; \
  sudo apt-get install -y apt-transport-https && \
  sudo apt-get update && \
  sudo apt-get install -y dotnet-sdk-5.0

# rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
cargo install exa


# nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash


# yarn
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update && sudo apt -y install yarn

# Setup links
echo 'export ZDOTDIR=~/.config/zsh' > ~/.zshenv

ln -s ~/.config/editorconfig ~/.editorconfig
ln -s ~/.config/gitconfig ~/.gitconfig
ln -s ~/.config/bashrc ~/.bashrc
