#!/bin/bash
####################
## Vornei Augusto Grella - Instalacao de programas para o Debian 10 Buster
## Esse programa deve ser executado como root e pode ser executado mais de uma vez
## Porem os comandos SED foram comentados e devem ser executados manualmente
## senao ira acarretar em problemas em arquivos do sudoers e sources.list, por exemplo
## por isso essas linhas foram comentadas e recomendo no caso do sudoers, conferir se
## o SED funcionou
## Importante: nao esqueca de colocar o usuario administrador (ex: vagrella), nos groups desejados
####################

####################
## Variaveis de Configuracao
####################
DATA=`date +%Y%m%d%Y_%H%M%S`

USER_ADM='vagrella'
AMBIENTE_FEEC=0
AMBIENTE_GGTE=0

#VERSION_DEBIAN='bookworm'
VERSION_DEBIAN=$(lsb_release -cs)

REP_DEBIAN='http://deb.debian.org/debian/'
REP_DEBIAN_SEC='http://security.debian.org/debian-security'
REP_BACKPORTS='http://ftp.debian.org/debian '$VERSION_DEBIAN'-backports'
REP_DOCKER='https://download.docker.com/linux/debian'
REP_MONGODB='http://repo.mongodb.org/apt/debian'

APT_DOCKER=/etc/apt/sources.list.d/docker.list
APT_SIGNAL=/etc/apt/sources.list.d/signal-messenger.list
APT_VIRTUAL_BOX=/etc/apt/sources.list.d/virtualbox.list
APT_VISUAL_CODE=/etc/apt/sources.list.d/vscode.list

DIR_LOCAL=$(pwd)
DIR_DEV=/home/dev

DIR_DEV_DOCKER=$DIR_DEV/docker
DIR_DEV_HTML=$DIR_DEV/html
DIR_DEV_JAVA=$DIR_DEV/java
DIR_DEV_PYTHON=$DIR_DEV/python

DIR_WORK=$DIR_DEV/unicamp/FEEC
DIR_WORK_DOCKER=$DIR_WORK/docker
DIR_WORK_JAVA=$DIR_WORK/java
DIR_WORK_PYTHON=$DIR_WORK/python
DIR_WORK_WWW=$DIR_WORK/www

DIR_LUDOPEDIO=$DIR_DEV/ludopedio

DIR_PROGRAM=/home/program
DIR_JVM=$DIR_PROGRAM/jvm
DIR_JRE=$DIR_JVM/jre1.8.0_241
DIR_USER_ADM=/home/$USER_ADM
DIR_XEN=$DIR_PROGRAM/openxenmanager
DIR_WWW=/var/www

DIR_DOWNLOAD=$DIR_USER_ADM/Downloads

FILE_AWS='awscli-exe-linux-x86_64.zip'
FILE_AWS_DEB='session-manager-plugin.deb'
FILE_CHROME='google-chrome-stable_current_amd64.deb'
FILE_INSOMNIA='latest'
FILE_JVM='jre-8u241-linux-x64.tar.gz'
ID_JVM='AutoDL?BundleId=241526_1f5b5a70bf22433b84d0e960903adac8'
FILE_NOMACHINE='nomachine_6.9.2_1_amd64.deb'
FILE_PYCHARM='pycharm-community-2023.3.4.tar.gz'
FILE_QWBFS='qwbfsmanager-1.2.1-src.tar.gz'
FILE_RABBITVCS='rabbitvcs-nautilus_0.18-3_all.deb.html'
FILE_TEAM='teamviewer_amd64.deb'
FILE_VEROBR='VeroptBRV320AOC.oxt'
FILE_WB='mysql-workbench-community_8.0.16-1ubuntu18.04_amd64.deb'
FILE_ZOOM='zoom_amd64.deb'

####################
## Realizar ou não algumas instalações 
## Não = 0
## Sim = 1
####################
## Desenvolvimento:
####################
INSTALL_ANDROID=1
INSTALL_DOCKER=1
INSTALL_ECLIPSE=0
INSTALL_JVM=0
INSTALL_KVM=0
INSTALL_NODEJS=0
INSTALL_PHP=1
INSTALL_PYCHARM=1
## Se for usar maven (versão 3.2)
## Cuidado: Tem conflitos em projetos com a versão 2
INSTALL_MAVEM=0
INSTALL_MONGODB=0
## De preferencia usar docker, se for usar, nao tem necessidade de instalar MySQL
INSTALL_MYSQL=0
INSTALL_SQUIRREL=1
INSTALL_VIRTUAL_BOX=0
INSTALL_VISUAL_CODE=1
INSTALL_WB=0
INSTALL_WIRESHARK=1
INSTALL_WWW=1
####################
## Sitema, rede e media:
####################
## Atenção caso instalar o desktop record, olhar o xdg
INSTALL_DESKTOP_RECORD=1
INSTALL_DROPBOX=1
INSTALL_INSOMNIA=0
INSTALL_NOMACHINE=0
INSTALL_SIGNAL=1
INSTALL_TEAM=0
INSTALL_TELEGRAM=1
INSTALL_WHATSAPP=1
## ATENÇÃO: Instalar o xdg para resolver o problema de Compartilhar Tela no Meet
## resolve o problema "Tela Preta apresentação Google Meet"
## Mas não será possível gravar o Desktop, com os programas Record My Desktop e
## Simple Screen Recorder (simplescreenrecorder), pois são conflitantes.
INSTALL_XDG=1
INSTALL_XEN=0
INSTALL_ZOOM=1
####################
## Outros :
####################
INSTALL_AWS=0
INSTALL_CHROMECAST=0
INSTALL_OCTAVE=1
INSTALL_QBREW=1
INSTALL_QWBFS=0

####################
## Correções especificas de problemas:
####################
ERRO_DATEN=0

####################
## Verificar se esta como root
####################
SUPER_USER=$(whoami)
if [ "$SUPER_USER" != "root" ]; then
    echo 'Usuário não é root! Você está logado com '$SUPER_USER
    echo 'Realize o acesso como Super Usuario (root), para executar o script.'
    echo "Execute o comando: 'sudo -i' ou 'su -'"
    exit 0
fi

####################
## Avisos e incluir ao sudoers
####################
echo '####################'
echo 'Antes de continuar, realize as etapas:'
echo '1 - Coloque o usuario '$USER_ADM' no arquivo /etc/sudoers. Adicione a linha abaixo: '
echo $USER_ADM' ALL=(ALL:ALL) ALL'
echo '2 - Caso o usuário acima não for o desejado, edite o arquivo de instalação (em '$DIR_LOCAL') na variável USER_ADM'
echo '####################'
echo 'Essas etapas foram realizadas para poder continuar? [s/N]:'
read RESP
if [ ! "$RESP" == "s" ]; then
    echo 'Terminado! Voce digitou "'$RESP'", se desejava continuar digite exatamente "s" (minusculo) '
    exit 0
fi

####################
## Correção de erros e problemas
####################
if [ $ERRO_DATEN == 1 ]; then
    echo '####################'
    echo 'Acertando ambiente para DATEN...'
    
    if [ ! -e /lib/systemd/system-sleep/r8169-refresh ]; then
        #Criado script em /lib/systemd/system-sleep/ com o nome r8169-refresh, contendo o seguinte código:
        echo '#!/bin/bash

PROGNAME=$(basename "$0")
state=$1
action=$2

function log {
    logger -i -t "$PROGNAME" "$*"
}

log "Running $action $state"

if [[ $state == post ]]; then
    modprobe -r r8169 \
    && log "Removed r8169" \
    && modprobe -i r8169 \
    && log "Inserted r8169"
fi' > /lib/systemd/system-sleep/r8169-refresh
    fi
    
    if [ -e /lib/systemd/system-sleep/r8169-refresh ]; then
        #Colocar permissão de execução no arquivo com o comando:
        chmod +x /lib/systemd/system-sleep/r8169-refresh
        cat /lib/systemd/system-sleep/r8169-refresh
        echo '####################'
        echo 'Ambiente DATEN OK! Pressione qualquer tecla para continuar...'
        read RESP
    else
        echo 'ERRO: Arquivo /lib/systemd/system-sleep/r8169-refresh não encontrado!'
        exit 0
    fi
else
    rm /lib/systemd/system-sleep/r8169-refresh
fi

if [ ! -d "$DIR_DOWNLOAD" ]; then
    echo 'Criando diretorio de Download'
    mkdir -p $DIR_DOWNLOAD;
else
    echo 'Diretório '$DIR_DOWNLOAD' existente!'
fi
chmod 777 $DIR_DOWNLOAD
cd $DIR_DOWNLOAD

####################
## Preparando Alias
####################
cat /etc/bash.bashrc
echo '####################'
echo 'Verifique o arquivo /etc/bash.bashrc (acima)'
echo 'Deseja criar os Alias no arquivo? [s/N]: '
echo '####################'
read RESP
if [ "$RESP" == "s" ]; then
    echo 'Criando Alias em /etc/bash.bashrc'
    ## Backup bash
    if [ ! -e /etc/bash.bashrc.original ]; then
        echo 'Salvando cópia do arquivo bash.bashrc em bash.bashrc.original'
        cp /etc/bash.bashrc /etc/bash.bashrc.original
    fi
    
    cp /etc/bash.bashrc /etc/bash.bashrc.bkp
    
    echo '### Vornei'  >> /etc/bash.bashrc
    echo "alias ls='ls --color=auto'" >> /etc/bash.bashrc
    echo "alias vi='vi -c \"syntax on\" -c \"set number\" -c \"set mouse-=a\" '" >> /etc/bash.bashrc
    echo "alias manage='python "'$VIRTUAL_ENV/manage.py'"'" >> /etc/bash.bashrc
    if [ $INSTALL_MAVEM == 1 ]; then
        echo '' >> /etc/bash.bashrc
        echo '#export MAVEN_HOME="/home/program/maven/apache-maven-2.2.1/"' >> /etc/bash.bashrc
        echo '# Set o PATH com o MAVEN_HOME' >> /etc/bash.bashrc
        echo '#export PATH="$MAVEN_HOME/bin:$PATH"' >> /etc/bash.bashrc
    fi
fi

####################
## Criando local/ambiente de programas instalados
####################
if [ ! -d "$DIR_PROGRAM" ]; then
    echo '####################'
    echo 'Criando local/ambiente de Programas:'
    echo '####################'
    mkdir -p $DIR_PROGRAM;
else
    echo 'Diretório '$DIR_PROGRAM' existente!'
fi
chown -R $USER_ADM:$USER_ADM $DIR_PROGRAM
chmod -R g+w $DIR_PROGRAM

####################
## Java - JVM e JRE
####################
if [ $INSTALL_JVM == 1 ]; then
    echo 'Criando diretorio: '$DIR_JVM
    if [ ! -d $DIR_JVM ]; then
        mkdir -p $DIR_JVM;
    else
        echo 'Diretório '$DIR_JVM' existente!'
    fi
    chown -R $USER_ADM:$USER_ADM $DIR_JVM
    cd $DIR_JVM
    wget https://javadl.oracle.com/webapps/download/$ID_JVM $DIR_JVM
    mv $ID_JVM $FILE_JVM
    chown -R $USER_ADM:$USER_ADM $FILE_JVM
    tar -xvf $FILE_JVM
    chown -R $USER_ADM:$USER_ADM $DIR_JRE

    echo '' >> /etc/bash.bashrc
    echo '#JVM - JRE instalado' >> /etc/bash.bashrc
    echo 'export JAVA_HOME="'$DIR_JRE'"' >> /etc/bash.bashrc
    echo 'export PATH="$JAVA_HOME/bin:$PATH"' >> /etc/bash.bashrc

fi


####################
## Criando ambiente de desenvolvimento
####################
if [ ! -d $DIR_DEV ]; then 
    echo 'Criando ambiente DEV'
    mkdir -p $DIR_DEV
    ln -s $DIR_DEV $DIR_USER_ADM
else
    echo 'Diretório '$DIR_DEV' existente!'
fi
## Docker
if [ ! -d $DIR_DEV_DOCKER ]; then 
    echo 'Criando ambiente DEV de DOCKER'
    mkdir -p $DIR_DEV_DOCKER
else
    echo 'Diretório '$DIR_DEV_DOCKER' existente!'
fi
## HTML
if [ ! -d $DIR_DEV_HTML ]; then 
    echo 'Criando ambiente DEV de HTML'
    mkdir -p $DIR_DEV_HTML
    
    if [ $INSTALL_PHP == 1 ]; then
        echo '<?php phpinfo();?>' > $DIR_DEV_HTML/info.php
    fi
else
    echo 'Diretório '$DIR_DEV_HTML' existente!'
fi
## Java
if [ ! -d $DIR_DEV_JAVA ]; then 
    echo 'Criando ambiente DEV WORK de Java'
    mkdir -p $DIR_DEV_JAVA
else
    echo 'Diretório '$DIR_DEV_JAVA' existente!'
fi
## Python
if [ ! -d $DIR_DEV_PYTHON ]; then 
    echo 'Criando ambiente DEV WORK de Python'
    mkdir -p $DIR_DEV_PYTHON
else
    echo 'Diretório '$DIR_DEV_PYTHON' existente!'
fi

## Work - Os links dos projetos somente serao criados depois de realizado o Git Clone do Projetos
if [ ! -d $DIR_WORK ]; then 
    echo 'Criando ambiente WORK'
    mkdir -p $DIR_WORK
else
    echo 'Diretório '$DIR_WORK' existente!'
fi
## Work Docker
if [ ! -d $DIR_WORK_DOCKER ]; then 
    echo 'Criando ambiente WORK de Docker'
    mkdir -p $DIR_WORK_DOCKER
    mkdir -p $DIR_WORK_DOCKER/alpine/db/maria-db
else
    echo 'Diretório '$DIR_WORK_DOCKER' existente!'
fi
## Work Java
if [ ! -d $DIR_WORK_JAVA ]; then 
    echo 'Criando ambiente WORK de Java'
    mkdir -p $DIR_WORK_JAVA
else
    echo 'Diretório '$DIR_WORK_JAVA' existente!'
fi
## Work Python
if [ ! -d $DIR_WORK_PYTHON ]; then 
    echo 'Criando ambiente WORK de Python'
    mkdir -p $DIR_WORK_PYTHON
else
    echo 'Diretório '$DIR_WORK_PYTHON' existente!'
fi
## Work WWW
if [ ! -d $DIR_WORK_WWW ]; then 
    echo 'Criando ambiente WORK de WWW'
    mkdir -p $DIR_WORK_WWW
else
    echo 'Diretório '$DIR_WORK_WWW' existente!'
fi

## Acertando permissoes
chown -R $USER_ADM:$USER_ADM $DIR_DEV
chmod -R g+w $DIR_DEV

echo 'Analise o diretorio: '$DIR_DEV
cd $DIR_DEV
pwd
ls -alh $DIR_DEV

echo 'Analise o diretorio: '$DIR_WORK
cd $DIR_WORK
pwd
ls -alh $DIR_WORK

echo '####################'
echo 'Confirme se os diretorios para Ambiente DEV foram criados corretamente.'
echo 'Deseja continuar com a INSTALAÇÃO? [s/N]: '
echo '####################'
read RESP
if [ "$RESP" != "s" ]; then
    echo 'Terminado! Voce digitou "'$RESP'", se desejava continuar digite exatamente "s" (minusculo) '
    exit 0
fi

cd $DIR_DOWNLOAD

####################
## Adicionando ao sudoers
## Não funcionou no momento, pois existe um TAB
####################
#chmod u+w /etc/sudoers
#sed -i 's/root    ALL=(ALL:ALL) ALL/root    ALL=(ALL:ALL) ALL\/n'$USER_ADM' ALL=(ALL:ALL) ALL/' /etc/sudoers
#chmod u-w /etc/sudoers

####################
## Pré-instalação - Pacotes essenciais
####################
apt-get update
apt-get -y install wget curl dirmngr 
apt-get -y install software-properties-common apt-transport-https ca-certificates gnupg2 lsb-release
apt-get -y install snapd
snap install core

####################
## Preparando Repositorios
####################
echo '####################'
echo 'ATENÇÃO: Se for primeira instalação é preciso incluir alguns repositórios para que funcionem todas as instalações. Caso já tenha rodado esse script, não é necessário realizar.'
echo 'Deseja alterar o Repositório? [s/N]: '
echo '####################'
read RESP
if [ "$RESP" == "s" ]; then
    ## Backup repositorio
    if [ ! -e /etc/apt/sources.list.original ]; then
        cp /etc/apt/sources.list /etc/apt/sources.list.original
    fi
    mv /etc/apt/sources.list /etc/apt/sources.list_$DATA
    
    # ORIGINAL source.list
####################
# deb cdrom:[Debian GNU/Linux 12 _Bookworm_ - Official Snapshot amd64 LIVE/INSTALL Binary 20230610-08:51]/ bookworm main non-free-firmware
#deb http://deb.debian.org/debian/ bookworm main
#deb-src http://deb.debian.org/debian/ bookworm main

#deb http://security.debian.org/debian-security bookworm-security main
#deb-src http://security.debian.org/debian-security bookworm-security main

# bookworm-updates, to get updates before a point release is made;
# see https://www.debian.org/doc/manuals/debian-reference/ch02.en.html#_updates_and_backports
#deb http://deb.debian.org/debian/ bookworm-updates main
#deb-src http://deb.debian.org/debian/ bookworm-updates main
####################

    touch /etc/apt/sources.list
    echo '#---------------------------------------#' >> /etc/apt/sources.list
    echo '# Repositório criado pelo Programa de Vornei Augusto Grella. ' >> /etc/apt/sources.list
    echo '# Oficiais: ' >> /etc/apt/sources.list
    echo '#---------------------------------------#' >> /etc/apt/sources.list

    add-apt-repository 'deb '$REP_DEBIAN' '$VERSION_DEBIAN' main contrib non-free-firmware'
    add-apt-repository 'deb-src '$REP_DEBIAN' '$VERSION_DEBIAN' main'
    
    add-apt-repository 'deb '$REP_DEBIAN' '$VERSION_DEBIAN'-updates main'
    add-apt-repository 'deb-src '$REP_DEBIAN' '$VERSION_DEBIAN'-updates main'
    
    add-apt-repository 'deb '$REP_DEBIAN_SEC' '$VERSION_DEBIAN'-security main contrib non-free-firmware'
    add-apt-repository 'deb-src '$REP_DEBIAN_SEC' '$VERSION_DEBIAN'-security main'
    
    echo '' >> /etc/apt/sources.list
    echo '#---------------------------------------#' >> /etc/apt/sources.list
    echo '#Informações by VORNA:' >> /etc/apt/sources.list
    echo '# Caso de erros e atualizações de PACOTES' >> /etc/apt/sources.list
    echo '# alguns comandos uteis: ' >> /etc/apt/sources.list
    echo '#' >> /etc/apt/sources.list
    echo '######## APT ############' >> /etc/apt/sources.list
    echo '### Para atualizar/limpar o repositório:' >> /etc/apt/sources.list
    echo '# apt-get update'  >> /etc/apt/sources.list
    echo '# apt-get clean.'  >> /etc/apt/sources.list
    echo '#' >> /etc/apt/sources.list
    echo '### Para atualizar / arrumar os pacotes:' >> /etc/apt/sources.list
    echo '# apt-get upgrade'  >> /etc/apt/sources.list
    echo '#####Intalar pacotes básicos e tenta atualizar todo o sistema:' >> /etc/apt/sources.list
    echo '# apt-get dist-upgrade'  >> /etc/apt/sources.list
    echo '# apt-get autoremove'  >> /etc/apt/sources.list
    echo '# apt-get --fix-broken install'  >> /etc/apt/sources.list
    echo '#' >> /etc/apt/sources.list
    echo '### Para instalar o pacote:' >> /etc/apt/sources.list
    echo '# apt-get install NOME_DO_PACOTE'  >> /etc/apt/sources.list
    echo '#' >> /etc/apt/sources.list
    echo '### Para remover o pacote:' >> /etc/apt/sources.list
    echo '# apt-get remove NOME_DO_PACOTE'  >> /etc/apt/sources.list
    echo '#' >> /etc/apt/sources.list
    echo '### Para problemas com a Chave:' >> /etc/apt/sources.list
    echo '# gpg --keyring /usr/share/keyrings/debian-keyring.gpg \
-a --export [NO_PUBKEY] | apt-key add -' >> /etc/apt/sources.list
    echo '######## DPKG ###########' >> /etc/apt/sources.list
    echo '# dpkg --configure -a'  >> /etc/apt/sources.list
    echo '### Para listar o(s) pacote(s):' >> /etc/apt/sources.list
    echo '# dgkg -l | grep PARTE_DO_NOME_DO_PACOTE' >> /etc/apt/sources.list
    echo '# dpkg -l | grep ^rc ' >> /etc/apt/sources.list
    echo '### Para REMOVER pacote:' >> /etc/apt/sources.list
    echo '# dpkg -P NOME_DO_PACOTE'  >> /etc/apt/sources.list
    echo '# dpkg --remove -force --force-remove-reinstreq NOME_DO_PACOTE' >> /etc/apt/sources.list
    echo '######## NA MAO #########' >> /etc/apt/sources.list
    echo '# rm /var/lib/apt/lists/* -vf'  >> /etc/apt/sources.list
    echo '#---------------------------------------#' >> /etc/apt/sources.list
    echo '' >> /etc/apt/sources.list
    echo '## Repositorios da proxima versao Debian Sid/Unstable:' >> /etc/apt/sources.list
    echo '# Util para instalacoes de pacotes na versao instavel dpkg-dev, etc...' >> /etc/apt/sources.list
    echo '# deb http://ftp.us.debian.org/debian/ sid main contrib non-free' >> /etc/apt/sources.list
    echo '# deb http://ftp.us.debian.org/debian/ unstable main contrib non-free' >> /etc/apt/sources.list
    
    ## Problemas com o repositório Backports
    #add-apt-repository 'deb '$REP_BACKPORTS' '$VERSION_DEBIAN'-backports main'
    rm /etc/apt/sources.list.d/archive_uri-http_deb_debian_org_debian_-bookworm.list
    rm /etc/apt/sources.list.d/archive_uri-http_ftp_debian_org_debian-bookworm.list
    rm /etc/apt/sources.list.d/archive_uri-http_security_debian_org_debian-security-bookworm.list
    

    
    ####################
    ## Repositorio Docker
    ####################
    if [ $INSTALL_DOCKER == 1 ]; then
        install -m 0755 -d /etc/apt/keyrings
        curl -fsSL $REP_DOCKER/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
        chmod a+r /etc/apt/keyrings/docker.gpg
        echo \
      "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] $REP_DOCKER \
      "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
      sudo tee $APT_DOCKER > /dev/null
    fi
    
    ####################
    ## Repositorio MongoDB
    ####################
    if [ $INSTALL_MONGODB == 1 ]; then
        echo \
        "deb [ signed-by=/usr/share/keyrings/mongodb-server-6.0.gpg] $REP_MONGODB \
         $VERSION_DEBIAN/mongodb-org/6.0 main" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list
         
         apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys 6A26B1AE64C3C388
    fi
    ####################
    ## Repositorio Signal
    ####################
    if [ $INSTALL_SIGNAL == 1 ]; then
        if [ ! -e $APT_SIGNAL ]; then
            curl -fsSL https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor | sudo tee /usr/share/keyrings/signal-desktop-keyring.gpg > /dev/null
            echo "deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main" | sudo tee $APT_SIGNAL
        fi
    fi
    ####################
    ## Repositório Virtualbox
    ## https://linuxdicasesuporte.blogspot.com/2021/08/instalar-o-virtualbox-no-debian-11.html
    ## https://wiki.debian.org/VirtualBox
    ## ATENÇÃO: Para o caso da BIOS conter EFI Security Boot colocar como OFF por causa do erro de 
    ## kernel
    ####################
    if [ $INSTALL_VIRTUAL_BOX == 1 ]; then
        if [ ! -e $APT_VIRTUAL_BOX ]; then
            echo "deb [arch=amd64 signed-by=/usr/share/keyrings/oracle-virtualbox-2016.gpg] https://download.virtualbox.org/virtualbox/debian bookworm contrib" > $APT_VIRTUAL_BOX
            # Importar a chache GPG
            curl https://www.virtualbox.org/download/oracle_vbox_2016.asc | gpg --dearmor --yes --output /usr/share/keyrings/oracle-virtualbox-2016.gpg
        fi
    fi
    ####################
    ## Repositorio Visual Code
    ####################
    if [ $INSTALL_VISUAL_CODE == 1 ]; then
        curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
        install -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/microsoft-archive-keyring.gpg
        echo "deb [arch=amd64,arm64,armhf signed-by=/usr/share/keyrings/microsoft-archive-keyring.gpg] https://packages.microsoft.com/repos/vscode stable main" > $APT_VISUAL_CODE
    fi
fi
## Atualizar repositorio:
apt-get update

echo '####################'
echo 'Confirme se os repositórios estão OK.'
echo 'Deseja continuar com a INSTALAÇÃO? [s/N]: '
echo '####################'
read RESP
if [ "$RESP" != "s" ]; then
    echo 'Terminado! Voce digitou "'$RESP'", se desejava continuar digite exatamente "s" (minusculo) '
    exit 0
fi
####################
## Iniciando Instalacoes
####################
apt-get -y install vim
####################
## Sistemas / Redes e Ferramentas de cripto
####################
apt-get -y install gnome-control-center alacarte
apt-get -y install openssh-server seahorse-nautilus sshfs
apt-get -y install firmware-linux-nonfree firmware-realtek
apt-get -y install net-tools dnsutils nmap traceroute putty
apt-get -y install samba nautilus-share

## Gerenciamento Git pelo Nautilus (Não tem o pacote para o Debian12)
#apt-get -y install rabbitvcs-nautilus
#if [ ! -e $FILE_RABBITVCS ]; then 
    #dependencia
#    apt -y install rabbitvcs-core
#    cd $DIR_DOWNLOAD
#    wget https://ubuntu.pkgs.org/22.04/ubuntu-universe-arm64/$FILE_RABBITVCS
#fi
#dpkg -i $FILE_RABBITVCS
#rm $DIR_DOWNLOAD/$FILE_RABBITVCS

####################
## Impressora e Scaner
## HP e todos os Drives: Escolher Drive HP Deskjet 3510 Series
####################
apt-get -y install cups hplip hpijs-ppds hplip-gui
## Scanner
apt-get -y install zmap
#apt-get install tesseract-ocr-por
#apt-get install hplib* -y
#apt-get install xsane -y
#apt-get install gscan2pdf

####################
## Outros - LEGAIS:
## Para Manipular imagens, som, ipod, wii, cerveja, etc...
####################
## Medias, Fotos, Audios e Videos 
apt-get -y install nautilus-image-converter
apt-get -y install sound-juicer soundconverter gtkpod
apt-get -y install vlc
## Alternativa ao VLC
#apt-get -y install winff

apt-get -y install libgtop2-common libgtop2-dev
apt-get -y install gstreamer1.0-vaapi

## Converter e copiar arquivos de vídeos
if [ $INSTALL_HAND_BRAKE == 1 ]; then
    apt-get -y install handbrake handbrake-cli
fi

## Editor de vídeo (Pacote não encontrado)
#apt-get -y install avidemux

## Gravar o Desktop - Record my Desktop foi substituido por SimpleScreenRecorder
## Problema de fundo de tela escuro
## https://www.youtube.com/watch?v=Uze5GeqDPb8
if [ $INSTALL_DESKTOP_RECORD == 1 ]; then
    #apt-get -y install recordmydesktop
    #apt-get -y install simplescreenrecorder
    apt-get -y install obs-studio
    
    # Edição de vídeo
    # Instalar Openshot: https://www.openshot.org/pt/download/
    # https://www.edivaldobrito.com.br/como-instalar-o-openshot-2-0-beta-no-ubuntu/
    apt-get -y install openshot-qt
fi

####################
## Tela Preta apresentação Google Meet
## https://sobrelinux.info/questions/353704/google-hangouts-screen-share-black-screen-error
## https://bbs.archlinux.org/viewtopic.php?id=263958
## https://libredd.it/r/archlinux/comments/pug5i1/google_meet_on_firefox_native_wayland_just_blank/
## https://bugs.launchpad.net/ubuntu/+bug/1918189
####################
if [ $INSTALL_XDG == 1 ]; then
    apt-get -y install xdg-desktop-portal-*
fi

## Brassagem e cerveja
if [ $INSTALL_QBREW == 1 ]; then
    apt-get -y install qbrew
fi

####################
## QWBFS - Wii
## http://dmdcosillas.blogspot.com/2011/04/qwbfs-manager-version-12-liberada.html
##
## Copiar o jogo para o HD
## ERRO:- Can not open partition:
## Nao foi o problema dos pacotes abaixo, nao precisa instalar
## build-essential qt4-qmake libssl-dev libqt4-dev libxext-dev libudev-dev 
## Basta verificar o dirve da paticao e dar total privilegio, exemplo se for sdb1, com comando:
## chmod 777 /dev/sdb1
####################
if [ $INSTALL_QWBFS == 1 ]; then
    apt-get -y install build-essential
    apt-get -y install libqt4-core libqt4-dev libqt4-gui libqt4-sql
    apt-get -y install libudev-dev
    cd $DIR_DOWNLOAD
    if [ ! -e $FILE_QWBFS ]; then 
        wget http://code.google.com/p/qwbfs/downloads/detail?name=$FILE_QWBFS&can=2&q=
    fi
    qmake PREFIX=/usr/local
    make
    make install
    rm $FILE_QWBFS
    ## Não funciona mais - Pacote não existe
    #apt-get -y install qwbfsmanager 
fi

####################
## Desinstalar programas do indesejados do Android:
## https://www.youtube.com/watch?v=NRA0EbDICio&list=LL&index=4
## https://www.youtube.com/watch?v=_fkOqZFRlUY
## https://github.com/0x192/universal-android-debloater/releases
####################
if [ $INSTALL_ANDROID == 1 ]; then
    apt-get -y install adb
    wget https://github.com/0x192/universal-android-debloater/releases/download/0.5.1/uad_gui-linux-opengl.tar.gz
fi

####################
## Matlab: Octave/MATLAB mex generator
####################
if [ $INSTALL_OCTAVE == 1 ]; then
    apt-get -y install octave mwrap
fi

####################
## BR Office
####################
apt-get -y install libreoffice-l10n-pt-br

## Navegador Web Falkon
apt-get -y install falkon

####################
## Instalando Google Chrome
####################
if [ ! -e $FILE_CHROME ]; then 
    cd $DIR_DOWNLOAD
    wget https://dl.google.com/linux/direct/$FILE_CHROME
    #dependencia
    apt -y install libu2f-udev
fi
dpkg -i $FILE_CHROME
rm $DIR_DOWNLOAD/$FILE_CHROME

####################
## Instalando Signal:
## https://signal.org/pt_BR/download/
####################
if [ $INSTALL_SIGNAL == 1 ]; then
    apt -y install signal-desktop
fi
####################
## Instalando Telegram:
####################
if [ $INSTALL_TELEGRAM == 1 ]; then
    apt -y install telegram-desktop
fi
####################
## Instalando Zoom:
## https://support.zoom.us/hc/pt-br/articles/204206269-Como-instalar-ou-atualizar-o-Zoom-no-Linux
####################
if [ $INSTALL_ZOOM == 1 ]; then
    apt -y install gdebi
    cd $DIR_DOWNLOAD
    if [ ! -e $FILE_ZOOM ]; then 
        wget https://zoom.us/client/latest/$FILE_ZOOM
    fi
    apt -y install ./$FILE_ZOOM
    rm $FILE_ZOOM

    ## Para remover
    #apt remove zoom
fi

####################
## Instalando Whatsapp:
## https://snapcraft.io/install/whatsapp-for-linux/debian
####################
if [ $INSTALL_WHATSAPP == 1 ]; then
    snap install whatsapp-for-linux
    ## Para utilizar basta executar o comando: whatsapp-for-linux
    ## Criar automátio no Menu Aplicativos > Internet > Whatsapp
    ## Para desistalar:
    # snap remove whatsapp-for-linux
fi

####################
## O pacote gksu não está mais disponível, mas é referenciado por outro pacote.
## Isto pode significar que o pacote está faltando, ficou obsoleto ou
## está disponível somente a partir de outra fonte
####################
#apt-get -y install gksu

####################
## VPN - Unicamp: 
## https://www.ccuec.unicamp.br/ccuec/material_apoio/tutorial_linux_vpn_versoes
## Para configurar o vpn, basta copiar o diretório vpn-unicamp
## Ler o README para configuração
## Caso precise baixar o arquivo:
## Abra o navegador e acesse: https://config.vpn.unicamp.br
## acesse com vagrella@unicamp.br
####################
apt -y install openvpn openvpn-systemd-resolved
apt -y install network-manager-openvpn network-manager-openvpn-gnome

## Conexões remotas
#apt-get -y install remmina rdesktop
## Se for servidor de acesso remoto RDP
#apt-get -y install xrdp

####################
## Dados, Sistema de arquivos e Forense
####################
apt-get -y install gparted htop

apt-get -y install forensics-extra-gui
## rootkit
apt-get -y install chkrootkit forensics-all rkhunter
apt-get -y install rsync

## Para manipular Sistema de Arquivo NFST
apt-get -y install udftools

if [ $INSTALL_WIRESHARK == 1 ]; then
    apt-get -y install wireshark
fi

####################
## Desenvolvimento:
####################
apt-get -y install git
## Para configurar o usuário no repositorio do git, execute os comandos, :
#git config --global user.name "Vornei Augusto Grella"
#git config --global user.email "vagrella@unicamp.br"

## Maven 3
if [ $INSTALL_MAVEM == 1 ]; then
    apt-get -y install maven
fi
apt-get -y install mariadb-client
apt-get -y install meld
apt-get -y install glade

apt-get -y install libcanberra-gtk-module libcanberra-gtk3-module 
apt-get -y install cmake cmake-gui build-essential checkinstall autoconf 
apt-get -y install libtool libcunit1-dev nettle-dev libyaml-dev libuv1-dev libssl-dev

## Python
apt-get -y install python3-setuptools
apt-get -y install python3-pip python3-venv virtualenv rrdtool python3-sphinx

## Bibliotecas Python: Repositório Debian:
apt-get -y install python3-numpy
apt-get -y install python3-pandas

## Debian adotou PEP668:
## https://linuxdicasesuporte.blogspot.com/2023/03/debian-12-bookworm-adota-o-pep-668-que.html
## para instalar pacotes PyPI: 
## pip install --break-system-packages mysql-connector 
## pip install --break-system-packages mysql-connector-pyth
## ou utilizar o pacote debian pipx (recomendado)
apt-get -y install pipx

## Utilizando PIP:
#pip install mysql-connector mysql-connector-python lambda
pipx install mysql-connector
pipx install mysql-connector-python

## Lambda não funcionou com pipx 
pip install --break-system-packages lambda

####################
## Virtme - Para trabalhar com o kernel do Linux
## https://github.com/amluto/virtme
## https://www.collabora.com/news-and-blog/blog/2018/09/18/virtme-the-kernel-developers-best-friend/
####################
pipx install git+https://github.com/ezequielgarcia/virtme.git

## PHP 8
if [ $INSTALL_PHP == 1 ]; then
    apt -y install php8.2
    apt -y install composer
    apt -y install php-mysql php-curl phpunit
    apt -y install ghostscript
    
    ####################
    ## Outras Bibliotecas PHP + Apache e MySQL
    ####################
    if [ $INSTALL_WWW == 1 ]; then
        apt -y install libapache2-mod-php
        apt -y install php-cli php-pear php-gmp php-gd php-bcmath php-mbstring php-xml php-zip
    fi
fi

## NodeJs
if [ $INSTALL_NODEJS == 1 ]; then
    apt-get -y install nodejs npm
    ## Corrigir problemas de versão
    curl https://www.npmjs.com/install.sh | sudo sh
    ## Caso deseje testar:
    #npm fund
fi

####################
## Sublime Text - Não instalo mais pois o Gedit faz tudo
####################
#apt-get -y install sublime-text

####################
## Instalando outros Programas e Ferramentas:
####################
if [ $INSTALL_WWW == 1 ]; then
    apt-get -y install apache2-utils
    
    ####################
    ## para usar o ab
    ## Ex: comando: ab -n 10000 -c 50  -k google.com.br/
    ## = 10 mil requisicoes e 50 usuarios, 200 requisicoes por usuario
    ####################
    #ab -n 10000 -c 50  -k google.com.br/
fi

####################
## Insomnia
## https://insomnia.rest/
## Cliente para Teste de APIs - enviar requisições HTTP
## ERRO: Não está compatível com a versão do Debian as libs abaixo
####################
if [ $INSTALL_INSOMNIA == 1 ]; then
    cd $DIR_DOWNLOAD
    apt-get -y install libappindicator3-0.1-cil libappindicator3-0.1-cil-dev
    wget https://updates.insomnia.rest/downloads/ubuntu/$FILE_INSOMNIA
    dpkg -i $FILE_INSOMNIA
    rm $FILE_INSOMNIA
fi

####################
## Virtualização
####################
## KVM - Qemu
if [ $INSTALL_KVM == 1 ]; then
    apt-get -y install qemu virt-manager
fi

## Virtual Box
if [ $INSTALL_VIRTUAL_BOX == 1 ]; then
    apt -y install virtualbox-7.0
    #apt-get -y install virtualbox
    #apt install virtualbox-ext-pack
fi

####################
## Instalando Team Viewer
## https://linuxize.com/post/how-to-install-teamviewer-on-debian-9/ 
####################
if [ $INSTALL_TEAM == 1 ]; then
    cd $DIR_DOWNLOAD
    if [ ! -e $FILE_TEAM ]; then 
        wget https://download.teamviewer.com/download/linux/$FILE_TEAM
    fi
    apt-get -y install ./$FILE_TEAM
    rm $FILE_TEAM
fi

####################
## Instalando Nomachine
## https://www.nomachine.com/download/download&id=6
####################
if [ $INSTALL_NOMACHINE == 1 ]; then
    cd $DIR_DOWNLOAD
    if [ ! -e $FILE_NOMACHINE ]; then 
        wget https://download.nomachine.com/6.9/Linux/$FILE_NOMACHINE
    fi
    dpkg -i $FILE_NOMACHINE
    rm $FILE_NOMACHINE
fi

####################
## Instalando Visual Studio Code (VSCode)
####################
if [ $INSTALL_VISUAL_CODE == 1 ]; then
    apt-get -y install code
    if [ ! -e /usr/bin/code ]; then
        apt-get -y reinstall code
    fi
fi

####################
## Instalando Pycham
####################
if [ $INSTALL_PYCHARM == 1 ]; then
    cd $DIR_DOWNLOAD
    wget https://download.jetbrains.com/python/$FILE_PYCHARM
    tar xzf pycharm-*.tar.gz -C /opt/
    wget https://img1.gratispng.com/20180412/dqw/kisspng-pycharm-integrated-development-environment-python-idea-5acfabf6d9ea03.3275523415235594148926.jpg -P /opt/pycharm-community-2023.3.4/
    mv /opt/pycharm-community-2023.3.4/kisspng-pycharm-integrated-development-environment-python-idea-5acfabf6d9ea03.3275523415235594148926.jpg /opt/pycharm-community-2023.3.4/logo.jpg
    ln -s /opt/pycharm-community-2023.3.4/bin/pycharm.sh /bin/pycharm

    ####################
    ## instalacao fica em /opt/pycharm-community-*/bin/pycharm.sh
    ## Para abrir o pycharm execute, na area do usuário gráfico, o comando: pycharm
    ## Crie um intem no Menu Name: "Pycharm ", comando: /bin/pycharm Comment: "Pycharm Community (2.3)"
    ## utilize a imagem de logo.jpg que foi baixada no dir /opt/pycharm-community-2021.2.3/
    ####################
    #su $USER_ADM
    #pycharm
    rm $FILE_PYCHARM
fi

####################
## Eclipse (https://www.itzgeek.com/how-tos/linux/debian/how-to-install-eclipse-ide-on-debian-9-ubuntu-16-04-linuxmint.html)
## No Debian vem com o Titan
####################
if [ $INSTALL_ECLIPSE == 1 ]; then
    apt -y install eclipse
    ## Outra maneira, caso deseje uma versão especifica:
    #wget http://mirror.umd.edu/eclipse/technology/epp/downloads/release/2020-06/R/eclipse-java-2020-06-R-linux-gtk-x86_64.tar.gz
    #tar -zxvf eclipse-java-2020-06-R-linux-gtk-x86_64.tar.gz -C /usr/
    #ln -s /usr/eclipse/eclipse /usr/bin/eclipse
fi

####################
## Repositório e Instalando Docker e Docker Composer
####################
if [ $INSTALL_DOCKER == 1 ]; then
    apt -y install docker-ce docker-ce-cli containerd.io
    systemctl enable docker
    #systemctl status docker
    apt-cache madison docker-ce
    
    ## Teste
    #echo 'Testando o Docker - comando: docker run --rm -it  --name test alpine:latest /bin/sh'
    #docker run --rm -it  --name test alpine:latest /bin/sh
fi

####################
## Apache 2
## https://blog.remontti.com.br/3006
####################
if [ $INSTALL_WWW == 1 ]; then
    apt-get -y install apache2
    ## O diretório web apontarah para o desenvolvimento
    mv $DIR_WWW/html $DIR_WWW/html_original
    ln -s $DIR_DEV_HTML $DIR_WWW/html
fi

if [ $INSTALL_MONGODB == 1 ]; then
    ####################
    ## Instalando MongoDB:
    ####################
    echo 'Instalando MongiDB'
fi

if [ $INSTALL_MYSQL == 1 ]; then
    ####################
    ## Instalando Servidor MySQL:
    ####################
    apt -y install mariadb-server
    
    echo " root sem senha, só dar enter no login mysql.
## Caso deseje colocar senha para root ou criar outro usuário:
USE mysql;
UPDATE user SET password=PASSWORD('teste123') WHERE User='root';
UPDATE user SET plugin='mysql_native_password';

## Criando um novo usuário
CREATE USER 'user'@'localhost' IDENTIFIED BY 'teste123';
GRANT ALL PRIVILEGES ON *.* TO 'user'@'localhost';

FLUSH PRIVILEGES;
quit;
    "
    ## Colocando Senha de root
    mysql -u root -p
fi

if [ $INSTALL_SQUIRREL == 1 ]; then
    ####################
    ## Instalando Squirrel:
    ####################
    snap install squirrelsql
fi

####################
## Workbench
## Instalando o Workbench
####################
if [ $INSTALL_WB == 1 ]; then
    cd $DIR_DOWNLOAD
    wget https://downloads.mysql.com/archives/get/p/8/file/$FILE_WB 
    dpkg -i $FILE_WB
    apt -f install
    rm $FILE_WB
fi

####################
## Instalando OpenXenManager
####################
if [ $INSTALL_XEN == 1 ]; then
    pip install configobj raven
    cd $DIR_PROGRAM
    git clone https://github.com/OpenXenManager/openxenmanager.git
    chown -R $USER_ADM:$USER_ADM $DIR_XEN
    echo '#!/bin/sh
cd $DIR_XEN
./openxenmanager > /usr/bin/xenmanager'
    chmod 755 /usr/bin/xenmanager
    ## Para iniciar o programa execute o comando: xenmanager
    
    ####################
    ## XVA-IMG: Converter XVA (extensao XEN), para QCOW2
    ## NAO FUNCIONOU
    ## https://chariotsolutions.com/blog/post/convert-citrix-xenserver-xva-image-to-kvm/
    ####################
    #cd $DIR_PROGRAM
    #git clone git clone https://github.com/eriklax/xva-img.git
    #cd xva-img/
    #cmake .
    #make install
    ####################
    ##Para converter execute:
    ## mkdir xva_uncompressed
    ## tar -xf virtual_machine.xva -C xva_uncompressed
    ## xva-img -p disk-export xva_uncompressed/Ref\:1/ virtual_machine.raw
    ## qemu-img convert -f raw -O qcow2 virtual_machine.raw virtual_machine.qcow2
    ####################
fi
cd $DIR_DOWNLOAD

####################
## Removendo Programas
####################
## Retirando o Thunderbird
apt-get -y remove thunderbird
## Retirando o Evolution
apt-get -y remove evolution
## Remover pacotes que não precisem mais
apt autoremove
####################
## Atualizando Programas
####################
apt upgrade
## Caso algum tenha ficado quebrado
apt --fix-broken install
apt upgrade

####################
## Acertando permissões e Grupos
## Colocando nos grupos
####################
echo '####################'
echo 'Inserir '$USER_ADM' nos Grupos (/etc/group)? [s/N]: '
echo '####################'
read RESP
if [ "$RESP" == "s" ]; then
    
    if [ ! -e /etc/group.original ]; then
        echo 'Salvando cópia do arquivo group em group.original'
        cp /etc/group /etc/group.original
    fi
    
    echo 'Salvando cópia do arquivo group em group.bkp'
    cp /etc/group /etc/group.bkp

    ## Coloca o [grupo], pertencendo ao [user] (login)
    usermod -aG adm,lp,cdrom,audio,dip,video,plugdev,netdev,bluetooth,scanner $USER_ADM
    usermod -aG www-data $USER_ADM
    sed -i "s|$USER_ADM:x:1000:|$USER_ADM:x:1000:www-data|g" /etc/group
    usermod -aG sambashare,lpadmin $USER_ADM

    if [ $INSTALL_KVM == 1 ]; then
        usermod -aG libvirt-qemu, libvirt $USER_ADM
        sed -i "s|$USER_ADM:x:1000:|$USER_ADM:x:1000:libvirt-qemu,libvirt,|g" /etc/group
    fi
    if [ $INSTALL_MYSQL == 1 ]; then
        usermod -aG mysql $USER_ADM
        #usermod -g $USER_ADM mysql
        sed -i "s|$USER_ADM:x:1000:|$USER_ADM:x:1000:mysql,|g" /etc/group
    else
        addgroup mysql
        usermod -aG mysql $USER_ADM
    fi
    if [ $INSTALL_DOCKER == 1 ]; then
        usermod -aG docker $USER_ADM
        #usermod -g $USER_ADM docker
        sed -i "s|$USER_ADM:x:1000:|$USER_ADM:x:1000:docker,|g" /etc/group
    fi
    if [ $INSTALL_VIRTUAL_BOX == 1 ]; then
        usermod -aG vboxusers $USER_ADM
    fi
    if [ $INSTALL_WIRESHARK == 1 ]; then
        usermod -aG wireshark $USER_ADM
        sed -i "s|$USER_ADM:x:1000:|$USER_ADM:x:1000:wireshark,|g" /etc/group
    fi
fi

cd $DIR_DOWNLOAD
####################
## Instalando Dropbox
####################
if [ $INSTALL_DROPBOX == 1 ]; then
    wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
    $USER_ADM/.dropbox-dist/dropboxd
fi


####################
## Desenvolvimento:
## Instalando os Projetos para serem baixados:
####################
echo '####################'
echo 'Ambiente(s)'
echo 'Deseja Instalar os Projetos de DEV nos ambientes? [s/N]: '
echo '####################'
read RESP
if [ "$RESP" == "s" ]; then
    
    if [ $INSTALL_PHP == 1 ]; then
        ## Teste se o PHP funcionou
        echo '<?php phpinfo(); ?>' > $DIR_DEV_HTML/phpinfo.php
        chown $USER_ADM:$USER_ADM $DIR_DEV_HTML/phpinfo.php
    fi
    
    if [ $AMBIENTE_FEEC == 1 ]; then
        ## Docker
        cd $DIR_WORK_DOCKER/alpine/db/maria-db/
        git clone https://gitlab.unicamp.br/feec/docker/alpine/db/maria-db/db_cg.git
        git clone https://gitlab.unicamp.br/feec/docker/alpine/db/maria-db/db_cpg.git
        git clone https://gitlab.unicamp.br/feec/docker/alpine/db/maria-db/db_integracao_dac.git
        git clone https://gitlab.unicamp.br/feec/docker/alpine/db/maria-db/db_eaip.git

        ## Python
        cd $DIR_WORK_PYTHON
        git clone https://gitlab.unicamp.br/feec/python/integracao-dac.git
        git clone https://gitlab.unicamp.br/feec/python/integracao-dgrh.git
        ## Subprojetos CPG
        mkdir cpg
        cd $DIR_WORK_PYTHON/cpg
        git clone https://gitlab.unicamp.br/feec/python/cpg/importa_dados_dac.git
        git clone https://gitlab.unicamp.br/feec/python/cpg/importa_dados_dgrh.git
        
        ## WWW
        cd $DIR_WORK_WWW
        git clone https://gitlab.unicamp.br/feec/www/autentica_feec.git
        git clone https://gitlab.unicamp.br/feec/www/cpg.git
        git clone https://gitlab.unicamp.br/feec/www/cg.git
        git clone https://gitlab.unicamp.br/feec/www/eaip.git
        
        ## Links
        cd $DIR_DEV_HTML
        ln -s $DIR_WORK_WWW/autentica_feec .
        ln -s $DIR_WORK_WWW/cpg .
        ln -s $DIR_WORK_WWW/cg .
        
        cd $DIR_DEV_DOCKER
        ln -s $DIR_WORK_DOCKER/alpine/db/maria-db/db_cg .
        ln -s $DIR_WORK_DOCKER/alpine/db/maria-db/db_cpg .
        ln -s $DIR_WORK_DOCKER/alpine/db/maria-db/db_integracao_dac .
        ln -s $DIR_WORK_DOCKER/alpine/db/maria-db/db_eaip .
        
        cd $DIR_DEV_PYTHON
        ln -s $DIR_WORK_PYTHON/integracao-dac
        ln -s $DIR_WORK_PYTHON/integracao-dgrh
        ln -s $DIR_WORK_PYTHON/cpg
    fi
    
    if [ $AMBIENTE_GGTE == 1 ]; then
        cd $DIR_DEV_HTML
        git clone https://gitlab.unicamp.br/ccsist/abertura_area.git
    fi
    
    chmod -R g+w $DIR_DEV
    chown -R $USER_ADM:$USER_ADM $DIR_DEV
fi

####################
## AWS - Para utilizacao e acesso do Ludopedio
## https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html#cliv2-linux-install
## https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html#install-plugin-linux
####################
if [ $INSTALL_AWS == 1 ]; then
    cd $DIR_DOWNLOAD
    curl "https://awscli.amazonaws.com/$FILE_AWS" -o "awscliv2.zip"
    unzip awscliv2.zip
    ./aws/install

    curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/$FILE_AWS_DEB" -o "$FILE_AWS_DEB"
    dpkg -i $FILE_AWS_DEB

    ####################
    # Diretorio para montar o ludopedio
    # https://www.hiroom2.com/2017/08/04/ubuntu-1604-sshfs-en/
    ####################
    mkdir $DIR_LUDOPEDIO
    chown $USER_ADM:$USER_ADM $DIR_LUDOPEDIO
    chmod g+w $DIR_LUDOPEDIO
    sshfs ludopedio.com.br/usr/share/nginx/html:ec2-user $DIR_LUDOPEDIO
fi

echo '####################'
echo 'Verifique se eh necessario apagar um ou mais arquivos /etc/apt/sources.list_(DATA), gerado(s) automaticamente:'
ls -al /etc/apt/
echo '--------------------------------------------'
echo 'ATENÇÃO: Realize os procedimentos abaixo com o usuário '$USER_ADM':'
####################
# PYCHARM
####################
echo '1 - Crie um intem no Menu Name: "Pycharm ", comando: /bin/pycharm Comment: "Pycharm Community (2.3)"'
echo 'utilize a imagem de logo.jpg que foi baixada no dir /opt/pycharm-community-2021.2.3/'
echo '--------------------------------------------'
####################
## Instalar GNOME Extension
####################
cd $DIR_DOWNLOAD
echo 'Instalações do GNOME Extension.
Abra o Firefox e acesse:
https://extensions.gnome.org/extension/36/lock-keys/
https://extensions.gnome.org/extension/97/coverflow-alt-tab/
https://extensions.gnome.org/extension/3010/system-monitor-next/
https://extensions.gnome.org/extension/750/openweather/
https://extensions.gnome.org/extension/1765/transparent-topbar/
https://extensions.gnome.org/extension/1446/transparent-window-moving/
Já vem com o Linux só ativar:
https://extensions.gnome.org/extension/7/removable-drive-menu/
https://extensions.gnome.org/extension/6/applications-menu/
https://extensions.gnome.org/extension/8/places-status-indicator/' >> README_install_gnome_extensions.txt
echo '2 - Leia / Instale: README_install_gnome_extensions.txt'
echo '--------------------------------------------'
####################
## Corretor Gramatical LibreOffice usando Vero
## https://pt-br.libreoffice.org/projetos/vero
## https://sempreupdate.com.br/como-instalar-o-corretor-ortografico-no-libreoffice/
####################
if [ ! -e $DIR_DOWNLOAD/$FILE_VEROBR ]; then
    echo 'Baixando corretor gramatical BR Officedo em: '$DIR_DOWNLOAD/$FILE_VEROBR
    wget -O $DIR_DOWNLOAD/$FILE_VEROBR https://pt-br.libreoffice.org/assets/Uploads/PT-BR-Documents/VERO/$FILE_VEROBR
fi
## Para instalar o corretor ortográfico
echo '3 - Para instalar o corretor gramatical BR Office do Writer:'
echo 'Adicionar extensão no Write: Ferramentas > Gerenciador de extensões > Adicionar o arquivo '$DIR_DOWNLOAD/$FILE_VEROBR
echo '--------------------------------------------'
echo '4 - Copie as Chaves .ssh do Backup do Drives'
echo '--------------------------------------------'
echo 'Instalações concluídas!'

chmod -R 750 $DIR_DOWNLOAD
chown -R $USER_ADM:$USER_ADM .

echo '####################'
echo 'Permissão 750 em '$DIR_DOWNLOAD' restabelecida: '
ls -al $DIR_DOWNLOAD
if [ $INSTALL_VISUAL_CODE == 1 ]; then
    echo 'ATENÇÃO: Verifique se o VS Code foi instalado. Se não, adicione o arquivo microsoft.gpg ao chaveiro, isso pode ser feito com um duplo clique, e reinstale o VS CODE.'
fi
echo 'Não esqueça de APAGAR arquivos que não forem mais utilizados.'
echo '####################'

echo '####################'
echo 'Desejar REINICIAR (shutdown -r now)? [s/N]'
echo '####################'
read RESP
if [ "$RESP" == "s" ]; then
    shutdown -r now
else
    echo '####################'
    echo 'Desejar sair como usuário root? [s/N]'
    echo '####################'
    read RESP
    if [ "$RESP" == "s" ]; then
        exit
    fi
fi
