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

    sudo apt update && sudo apt -y upgrade
    sudo apt -y install \
        alacritty \
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
        fortune \
        lolcat \
        google-chrome-stable \
        code \
        spotify-client

    # nvm
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
    source ~/.bashrc
    nvm install lts/erbium

    # yarn
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
    sudo apt update
    # no install recommends since we installed node via nvm
    sudo apt install --no-install-recommends yarn

    # dotnet
    wget https://packages.microsoft.com/config/ubuntu/19.10/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
    sudo dpkg -i packages-microsoft-prod.deb
    sudo apt update
    sudo apt -y install apt-transport-https
    sudo apt -y update
    sudo apt -y install dotnet-sdk-3.1
    rm packages-microsoft-prod.deb

    sudo apt install docker.io
    sudo systemctl enable --now docker
    sudo usermod -aG docker $USER

    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    export PATH=~/.cargo/bin:$PATH
}

# https://dev.to/22mahmoud/my-terminal-became-more-rusty-4g8l
configure_rust() {
    rustup default stable
    cargo install exa
    cargo install cross
    cargo install starship
    cargo install bottom
    cargo install fd-find
    brew install ripgrep
}

configure_fonts() {
    ~/.config/content/fonts/install.sh
}


configure_nvim() {
  yarn global add neovim
  yarn global add typescript

  # from github.com/Shougu/deoplete.nvim#install
  pip3 install --user pynvim
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

configure_nvim
configure_rust
configure_fonts

exit $?
