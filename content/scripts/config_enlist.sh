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
        libssl-dev \
        lm-sensors \
        gnome-tweaks \
        spotify-client

    # candy icons
    pushd ~/repos
    git clone https://github.com/EliverLara/candy-icons
    mkdir -p ~/.icons/candy-icons
    cp -R ~/repos/candy-icons/* ~/.icons/candy-icons

    # nvm
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
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

function configure_fedora() {
    echo "This appears to be a Fedora system.  Configuring..."

    sudo dnf upgrade

    sudo dnf -y copr enable pschyska/alacritty

    sudo dnf -y install \
        neovim \
        util-linux-user \
        cmake \
        openssl-devel \
        alacritty \
        nodejs \
        nodejs-yarn \
        figlet \
        lolcat \
        cowsay \
        libX11-devel \
        libxkbfile-devel \
        libsecret-devel \
        zsh

    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash
    source ~/.bashrc
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
    nvm install 10

    chsh -s /usr/bin/zsh

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
    # brew install ripgrep
    # brew install git-delta
}

configure_fonts() {
    git clone https://github.com/markzuber/fonts.git ~/fonts
    ~/fonts/install.sh
}

configure_wallpaper() {
    git clone https://github.com/markzuber/wallpaper.git ~/wallpaper
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
    configure_fonts
    configure_wallpaper
fi

if [ -f "/usr/bin/apt" ]; then
    configure_ubuntu
    configure_fonts
    configure_wallpaper
fi

if [ -f "/usr/bin/yum" ]; then
    configure_fedora
fi

configure_nvim
configure_rust

exit $?
