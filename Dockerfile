from debian:buster

run apt-get update
run apt-get install -y build-essential git-core \
                       ninja-build gettext libtool\
                       libtool-bin autoconf automake \
                       cmake g++ pkg-config unzip \
                       sudo python3-pip

run adduser --disabled-password --gecos '' h4x0r
run adduser h4x0r sudo
run echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

run mkdir -p /opt/sources/rustup
workdir /opt/sources
run git clone git://github.com/neovim/neovim 
workdir /opt/sources/neovim
run git checkout stable
run make CMAKE_BUILD_TYPE=Release && make install

user h4x0r
workdir /home/h4x0r
run pip3 install --user neovim
run curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH=/home/h4x0r/.cargo/bin:$PATH

run rustup component add rust-src

run mkdir -p /home/h4x0r/sources
workdir /home/h4x0r/sources
run git clone https://github.com/rust-analyzer/rust-analyzer.git
workdir /home/h4x0r/sources/rust-analyzer
run cargo xtask install --server

run mkdir -p ~/.config/nvim
run curl -sL https://deb.nodesource.com/setup_12.x | sudo bash -
run sudo apt-get install -y nodejs

run sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
copy init.vim /home/h4x0r/.config/nvim/init.vim
copy coc-settings.json /home/h4x0r/.config/nvim/coc-settings.json
run nvim +VimEnter +PlugInstall +qall
run nvim -c "CocInstall -sync coc-rust-analyzer|qall"
env USER=h4x0r
