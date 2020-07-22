#!/bin/bash

git_pull_configs() {
    # Initial repo pull and setup
    if [ ! -d "$HOME/.config/.git" ]; then
        echo Pulling git configs into ~/.config...
        pushd $HOME/.config
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
    if [ -f "$HOME/.editorconfig" ]; then
        mv ~/.editorconfig ~/.editorconfig_original
    fi
    if [ -f "$HOME/.gitconfig" ]; then
        mv ~/.gitconfig ~/.gitconfig_original
    fi
    if [ -f "$HOME/.zshrc" ]; then
        mv ~/.zshrc ~/.zshrc_original
    fi
    if [ -f "$HOME/.bashrc" ]; then
        mv ~/.bashrc ~/.bashrc_original
    fi
    if [ -f "$HOME/.vimrc" ]; then
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

    sudo pacman --noconfirm --needed -S yay base-devel

    arch_pkgs=(
        'neovim',
        'dmenu',
        'cowsay',
        'figlet',
        'lolcat',
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
        'polybar',
        'docker',
        'zsh-autosuggestions',
        'zsh-syntax-highlighting')

    arch_pkg_args="${arch_pkgs[@]/,/ }"
    sudo pacman --noconfirm --needed -S $arch_pkg_args

    yay_pkgs=(
        'visual-studio-code-bin',
        'spotify',
        'ttf-ms-fonts',
        'google-chrome',
        'virtualbox-bin',
        'virtualbox-ext-oracle',
        'nerd-fonts-cascadia-code',
        'ttf-windows',
        'polybar',
        'dotnet-sdk-bin')

    yay_pkg_args="${yay_pkgs[@]/,/ }"
    yay --noconfirm --norebuild --noredownload --needed -S $yay_pkg_args
}

configure_ubuntu() {
    echo "This appears to be an Ubuntu/Debian based system.  Configuring..."
}

configure_rust() {
    rustup default stable
    cargo install exa
    cargo install cross
}

configure_fonts() {
  ~/.config/content/fonts/install.sh
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

configure_rust
configure_fonts

exit $?
