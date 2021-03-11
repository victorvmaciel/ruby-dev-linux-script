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
r
function instalar_rvm() {
    echo ""
	echo "Instalando o RVM em ${server_name}"
    sudo apt-get install gnupg gnupg -y
	gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
	sudo apt-get install curl -y
    \curl -sSL https://get.rvm.io | bash -s -- --version 1.29.10
    /bin/bash --login
    echo ""
    echo "RVM instalado com sucesso!"
}

function instalar_node() {
    echo ""
	echo "Instalando node em ${server_name}"
    echo ""
    curl -sL https://deb.nodesource.com/setup_12.16.3 | sudo -E bash - <https://deb.nodesource.com/setup_12.16.3
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
$(ColorGreen '5)') Instalar Ruby 2.4
$(ColorGreen '0)') Sair
$(ColorBlue 'Digite uma opção:') "
        read a
        case $a in
	        1) instalar_rvm ; menu ;;
	        2) instalar_node ; menu ;;
	        3) instalar_yarn ; menu ;;
	        4) install_ruby_2_7; menu ;;
	        5) install_ruby_2_4; menu ;;
		0) exit 0 ;;
		*) echo -e $red"Wrong option."$clear; WrongCommand;;
        esac
}

# Call the menu function
menu