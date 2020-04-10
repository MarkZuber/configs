#!/bin/bash

sudo apt update && sudo apt -y upgrade

# Large bundle of packages
sudo apt install \
    neofetch \
    neovim \
    zsh \
    zsh-autosuggestions \
    zsh-syntax-highlighting


# Alacritty
sudo add-apt-repository ppa:mmstick76/alacritty
sudo apt install alacritty

# dotnet
wget https://packages.microsoft.com/config/ubuntu/19.10/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt-get update
sudo apt-get install apt-transport-https
sudo apt-get update
sudo apt-get install dotnet-sdk-3.1
rm packages-microsoft-prod.deb

# rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
cargo install exa


# Setup links
echo 'export ZDOTDIR=~/.config/zsh' > ~/.zshenv

ln -s ~/.config/editorconfig ~/.editorconfig
ln -s ~/.config/gitconfig ~/.gitconfig
ln -s ~/.config/bashrc ~/.bashrc
