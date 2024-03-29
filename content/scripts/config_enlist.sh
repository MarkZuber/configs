#!/bin/bash

git_pull_configs() {
    # Initial repo pull and setup
    if [ ! -d "$HOME/.config"]; then
        mkdir "$HOME/.config"
    fi

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

    # doing install individually for each one in case a package name changes
    # or isn't available.

    sudo apt update && sudo apt -y upgrade
    sudo apt -y install build-essential # needed for rust projects
    sudo apt -y install libssl-dev # needed for starship
    sudo apt -y install pkg-config # needed for starship
    sudo apt -y install neofetch
    sudo apt -y install neovim
    sudo apt -y install zsh
    sudo apt -y install zsh-autosuggestions
    sudo apt -y install zsh-syntax-highlighting
    sudo apt -y install ttf-mscorefonts-installer
    sudo apt -y install ttf-bitstream-vera
    sudo apt -y install qbittorrent
    sudo apt -y install cmake
    sudo apt -y install gtk2-engines-murrine
    sudo apt -y install gtk2-engines-pixbuf
    sudo apt -y install cowsay
    sudo apt -y install figlet
    sudo apt -y install fortune
    sudo apt -y install lolcat
    sudo apt -y install google-chrome-stable
    sudo apt -y install code
    sudo apt -y install lm-sensors
    sudo apt -y install gnome-tweaks
    sudo apt -y install steam
    sudo apt -y install lutris
    sudo apt -y install htop
    sudo apt -y install bashtop
    sudo apt -y install vlc
    sudo apt -y install fonts-firacode
    sudo apt -y install tmux

    flatpak install -y flathub com.spotify.Client

    # youtube-dl
    sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl
    sudo chmod a+rx /usr/local/bin/youtube-dl
    sudo ln -s /usr/bin/python3 /usr/bin/python

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
    sudo apt-get update
    sudo apt-get install -y apt-transport-https 
    sudo apt-get update
    sudo apt-get install -y dotnet-sdk-6.0

    sudo apt install -y docker.io
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
        fortune-mod \
        lolcat \
        cowsay \
        gnome-tweak-tool \
        libX11-devel \
        libxkbfile-devel \
        libsecret-devel \
        zsh

    # install vscode
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
    sudo dnf check-update
    sudo dnf install code

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
    # cargo install tab
    cargo install cargo-update
    # brew install ripgrep
    # brew install git-delta
}

configure_fonts() {
    git clone --recurse-submodules https://github.com/markzuber/fonts.git ~/fonts
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
    configure_fonts
    configure_wallpaper
fi

configure_nvim
configure_rust

exit $?
