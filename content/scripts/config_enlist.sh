#!/bin/bash

git_pull_configs() {
    # Initial repo pull and setup
    if [ ! -f ~/.config/.git ]; then
        echo Pulling git configs into ~/.config...
        pushd ~/.config
        git init
        git remote add origin https://github.com/markzuber/configs
        git fetch origin
        git checkout -b master --track origin/master
        git reset origin/master
        git submodule update --init --recursive
        popd
    fi
}

configure_symlinks() {
    # Symlinks for config files
    if [ -f ~/.editorconfig ]; then
        mv ~/.editorconfig ~/.editorconfig_original
    fi
    if [ -f ~/.gitconfig ]; then
        mv ~/.gitconfig ~/.gitconfig_original
    fi
    if [ -f ~/.zshrc ]; then
        mv ~/.zshrc ~/.zshrc_original
    fi
    if [ -f ~/.bashrc ]; then
        mv ~/.bashrc ~/.bashrc_original
    fi
    if [ -f ~/.vimrc ]; then
        mv ~/.vimrc ~/.vimrc_original
    fi

    ln -s ~/.config/editorconfig ~/.editorconfig
    ln -s ~/.config/git/gitconfig ~/.gitconfig
    ln -s ~/.config/zsh/.zshrc ~/.zshrc
    ln -s ~/.config/bashrc ~/.bashrc
    ln -s ~/.config/nvim/init.vim ~/.vimrc

    echo 'export ZDOTDIR=~/.config/zsh' >~/.zshenv
}

configure_arch() {
    echo "This appears to be an Arch based system.  Configuring..."

    sudo pacman --noconfirm -S yay base-devel

    arch_pkgs=(
        'neovim',
        'cowsay',
        'figlet',
        'fortune-mod',
        'qbittorrent',
        'neofetch',
        'go',
        'rustup',
        'alacritty',
        'cmake',
        'youtube-dl',
        'yarn',
        'nodejs-lts-erbium',
        'docker',
        'zsh-autosuggestions',
        'zsh-syntax-highlighting')

    sudo pacman --noconfirm -S "${arch_pkgs[@]/#/-}"

    yay_pkgs=(
        'visual-studio-code-bin',
        'spotify',
        'ttf-ms-fonts',
        'google-chrome',
        'virtualbox-bin',
        'virtualbox-ext-oracle',
        'nerd-fonts-cascadia-code',
        'ttf-windows',
        'dotnet-sdk-bin')

    sudo yay --noconfirm -S "${yay_pkgs[@]/#/-}"
}

configure_ubuntu() {
    echo "This appears to be an Ubuntu/Debian based system.  Configuring..."
}

configure_rust() {
    rustup default stable
    cargo install exa
    cargo install cross
}

git_pull_configs
configure_symlinks

# Distro specific configs
if [ -f "/etc/arch-release" ]; then
    configure_arch
fi

if [ -f "/usr/bin/apt" ]; then
    configure_ubuntu
fi

exit $?
