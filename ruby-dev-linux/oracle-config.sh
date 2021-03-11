#! /bin/bash

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
echo "Reiniciar o terminal para validar as configurações"
sleep 2s 




