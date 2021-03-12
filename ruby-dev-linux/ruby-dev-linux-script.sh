#!/bin/bash

##
## RVM 1.29.10
## Ruby 2.7.1
## Rails 6.0.3.1
## Bundler 2.1.4
## Node.js v12.16.1
## Yarn 1.22.4
## Servidor Web "Nginx" version: nginx/1.10.3
## Servidor de aplicação puma
##

server_name=$(hostname)

function instalar_rvm() {
    echo ""
	echo "Instalando o RVM em ${server_name}"
    sudo apt-get install gnupg gnupg -y
	gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
	sudo apt-get install curl -y
    \curl -sSL https://get.rvm.io | bash -s -- --version 1.29.10
    /bin/bash --login
    sleep.10s
    echo "RVM instalado com sucesso!"
    echo ""
    
}

function instalar_node() {
    echo ""
	echo "Instalando node em ${server_name}"
    echo ""
    sudo apt update
    curl -sL https://deb.nodesource.com/setup_14.x -o nodesource_setup.sh
    sudo bash nodesource_setup.sh
    sudo apt-get install --yes nodejs
    echo ""
}

function instalar_yarn() {
    echo ""
	echo "Instalando yarn em ${server_name} "
    echo ""
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
    sudo apt-get update
    sudo apt-get -y install git-core \
    zlib1g-dev \
    build-essential \
    libssl-dev \
    libreadline-dev \
    libyaml-dev \
    libsqlite3-dev \
    sqlite3 \
    libxml2-dev \
    libxslt1-dev \
    libcurl4-openssl-dev \
    software-properties-common \
    libffi-dev \
    nodejs \
    yarn
    yarn config set "strict-ssl" false -g
    echo "" 
}

function install_ruby_2_7() {
    echo ""
	echo "Instalando Ruby 2.7 no ${server_name}"
	echo ""
    /bin/bash -l -c "source /usr/local/rvm/scripts/rvm"
    /bin/bash -l -c "rvm install 2.7.1"
    echo ""
}

function install_ruby_2_4() {
    echo ""
	echo "Instalando Ruby 2.4 no ${server_name}"
	echo ""
    /bin/bash -l -c "source /usr/local/rvm/scripts/rvm"
    /bin/bash -l -c "rvm install 2.4.2"
    echo ""
}

function install_bundle_rails() {
    gem install bundler
    gem install rails

}

function install_oracle() {
    echo ""
	echo "Instalando ORACLE em ${server_name}"
	echo ""
    sudo apt-get install -y unzip
    pwd && ls -la;
    echo "Criando pasta do oracle na /home do usuário"
        mkdir -p $HOME/oracle/instantclient_12_2/network/admin
    echo "Copiando o arquivo tsnames.ora"
        cp tnsnames.ora "$HOME/oracle/instantclient_12_2/network/admin"
    echo "Copiando arquivo .oracle para a home do usuário"
        cp -r .oracle $HOME
    echo "Copiando arquivos para a pasta oracle"
        cp *.zip $HOME/oracle
    echo "Descompactando arquivos"
        cd $HOME/oracle
        unzip instantclient-sdk-linux.x64-12.2.0.1.0.zip
        unzip instantclient-sqlplus-linux.x64-12.2.0.1.0.zip
        unzip -o instantclient-basic-linux.x64-12.2.0.1.0.zip
    echo "Criando link simbólico"
        ln -s $HOME/oracle/instantclient_12_2/libclntsh.so.12.1 $HOME/oracle/instantclient_12_2/libclntsh.so
    echo "Instalando lib"
        sudo apt-get install libaio1
    echo "Inserir as linhas ao .bashrc"
        echo source ~/.oracle >> ~/.bashrc
        echo source ~/.oracle >> ~/.profile
        source ~/.oracle
    
    sleep 2s 
    echo ""
    echo "instalar as gems do oracle"
    gem install ruby-oci8
    gem install activerecord-oracle_enhanced-adapter
}

function install_nvm(){

    echo ""
    echo "Instalando o nvm no ${server_name}"
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash
    export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
    /bin/bash --login
    nvm install 12.16.1
    nvm use 12.16.1 --default
    nvm alias defaut v12.16.1
    echo "Versão 12.16.1 instalada com sucesso!"
    echo ""
}

function install_postgres(){

    echo ""
    echo "Instalando dependências do postgres e gems necessárias no ${server_name}"
    sudo apt-get install build-essential libpq-dev
    gem install puma
    gem install pg
    echo "Gems instaladas com êxito"
    echo ""


}

##
# Color  Variables
##
green='\e[32m'
blue='\e[34m'
clear='\e[0m'

##
# Color Functions
##

ColorGreen(){
	echo -ne $green$1$clear
}
ColorBlue(){
	echo -ne $blue$1$clear
}

menu(){
echo -ne "
Ambiente Ruby on Rails 6
$(ColorGreen '1)') Instalar RVM
$(ColorGreen '2)') Instalar NODE
$(ColorGreen '3)') Instalar YARN
$(ColorGreen '4)') Instalar Ruby 2.7.1
$(ColorGreen '5)') Instalar Ruby 2.4.2
$(ColorGreen '6)') Instalar Bundler & Rails
$(ColorGreen '7)') Instalar Oracle
$(ColorGreen '8)') Instalar NVM
$(ColorGreen '9)') Instalar Postgres
$(ColorGreen '0)') Sair
$(ColorBlue 'Digite uma opção:') "
        read a
    case $a in
        1) instalar_rvm ; menu ;;
        2) instalar_node ; menu ;;
        3) instalar_yarn ; menu ;;
        4) install_ruby_2_7; menu ;;
        5) install_ruby_2_4; menu ;;
        6) install_bundle_rails; menu;;
        7) install_oracle menu;;
        8) install_nvm; menu;;
        9) install_postgres; menu;;
		0) exit 0 ;;
		*) echo -e $red"Wrong option."$clear; WrongCommand;;
        esac
}

# Call the menu function
menu
