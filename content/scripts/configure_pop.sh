#!/bin/bash

sudo apt update && sudo apt -y upgrade

# Large bundle of packages
sudo apt install zsh


# Alacritty
sudo add-apt-repository ppa:mmstick76/alacritty
sudo apt install alacritty



# Setup links

echo 'export ZDOTDIR=~/.config/zsh' > ~/.zshenv