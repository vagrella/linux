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

ALTERAR_REPOSITORIO=0
ALTERAR_GROUP=1

VERSION_DEBIAN='bullseye'
USER_ADM='vagrella'

DIR_DEV=/home/dev
DIR_DEV_HTML=$DIR_DEV/html
DIR_DEV_WORK=$DIR_DEV/unicamp/FEEC
DIR_DEV_WWW=$DIR_DEV_WORK/www
DIR_DEV_PYTHON=$DIR_DEV_WORK/python
DIR_DEV_DOCKER=$DIR_DEV_WORK/docker
DIR_DEV_JAVA=$DIR_DEV_WORK/java
DIR_PROGRAM=/home/program
DIR_JVM=$DIR_PROGRAM/jvm
DIR_JRE=$DIR_JVM/jre1.8.0_241
DIR_LUDOPEDIO=$DIR_DEV/ludopedio
DIR_USER_ADM=/home/$USER_ADM
DIR_XEN=$DIR_PROGRAM/openxenmanager
DIR_WWW=/var/www

FILE_AWS='awscli-exe-linux-x86_64.zip'
FILE_AWS_DEB='session-manager-plugin.deb'
FILE_CHROME='google-chrome-stable_current_amd64.deb'
FILE_INSOMNIA='latest'
FILE_JVM='jre-8u241-linux-x64.tar.gz'
ID_JVM='AutoDL?BundleId=241526_1f5b5a70bf22433b84d0e960903adac8'
FILE_NOMACHINE='nomachine_6.9.2_1_amd64.deb'
FILE_PYCHARM='pycharm-community-2021.2.3.tar.gz'
FILE_QWBFS='qwbfsmanager-1.2.1-src.tar.gz'
FILE_TEAM='teamviewer_amd64.deb'
FILE_TELEGRAM='tsetup.3.3.0.tar.xz'
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
## De preferencia usar docker, se for usar, nao tem necessidade de instalar MySQL
INSTALL_MYSQL=0
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
INSTALL_INSOMNIA=0
INSTALL_NOMACHINE=0
INSTALL_SIGNAL=1
INSTALL_TEAM=0
INSTALL_TELEGRAM=1
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
## Preparando Alias
####################
## Backup bash
cp /etc/bash.bashrc /etc/apt/bash.bashrc_$DATA
echo '### Vornei'  >> /etc/bash.bashrc
echo "alias ls='ls --color=auto'" >> /etc/bash.bashrc
echo "alias vi='vi -c \"syntax on\" -c \"set number \"'" >> /etc/bash.bashrc
echo "alias manage='python "'$VIRTUAL_ENV/manage.py'"'" >> /etc/bash.bashrc
if [ $INSTALL_MAVEM == 1 ]; then
    echo '' >> /etc/bash.bashrc
    echo '#export MAVEN_HOME="/home/program/maven/apache-maven-2.2.1/"' >> /etc/bash.bashrc
    echo '# Set o PATH com o MAVEN_HOME' >> /etc/bash.bashrc
    echo '#export PATH="$MAVEN_HOME/bin:$PATH"' >> /etc/bash.bashrc
fi

####################
## Criando local/ambiente de programas instalados
####################
if [ ! -d "$DIR_PROGRAM" ]; then
    echo 'Criando local/ambiente de Programas'
    mkdir -p $DIR_PROGRAM;
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
    mkdir $DIR_DEV
    ln -s $DIR_DEV $DIR_USER_ADM
fi
chown -R $USER_ADM:$USER_ADM $DIR_DEV
chmod -R g+w $DIR_DEV
## Work
if [ ! -d $DIR_DEV_WORK ]; then 
    echo 'Criando ambiente DEV de Work'
    mkdir $DIR_DEV_WORK
fi
chown -R $USER_ADM:$USER_ADM $DIR_DEV_WORK
chmod -R g+w $DIR_DEV_WORK
## WWW
if [ ! -d $DIR_DEV_WWW ]; then 
    echo 'Criando ambiente DEV de WWW'
    mkdir $DIR_DEV_WWW
    cd $DIR_DEV_WWW
    ## Projetos para serem baixados:
    ## Autentica
    git clone https://gitlab.unicamp.br/feec/www/autentica_feec.git
    ## CPG
    git clone https://gitlab.unicamp.br/feec/www/cpg.git
    ## CG
    git clone https://gitlab.unicamp.br/feec/www/cg.git
fi
chown -R $USER_ADM:$USER_ADM $DIR_DEV_WWW
chmod -R g+w $DIR_DEV_WWW
## Python
if [ ! -d $DIR_DEV_PYTHON ]; then 
    echo 'Criando ambiente DEV de Python'
    mkdir $DIR_DEV_PYTHON
    ln -s $DIR_DEV_PYTHON $DIR_DEV
fi
chown -R $USER_ADM:$USER_ADM $DIR_DEV_PYTHON
chmod -R g+w $DIR_DEV_PYTHON
## Docker
if [ ! -d $DIR_DEV_DOCKER ]; then 
    echo 'Criando ambiente DEV de Docker'
    mkdir $DIR_DEV_DOCKER
    ln -s $DIR_DEV_DOCKER $DIR_USER_ADM
fi
chown -R $USER_ADM:$USER_ADM $DIR_DEV_DOCKER
chmod -R g+w $DIR_DEV_DOCKER
## Java
if [ ! -d $DIR_DEV_DOCKER ]; then 
    echo 'Criando ambiente DEV de Java'
    mkdir $DIR_DEV_JAVA
    ln -s $DIR_DEV_JAVA $DIR_USER_ADM
fi
chown -R $USER_ADM:$USER_ADM $DIR_DEV_JAVA
chmod -R g+w $DIR_DEV_JAVA

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

####################
## Preparando Repositorios
####################
if [ $ALTERAR_REPOSITORIO == 1 ]; then
    ## Backup repositorio
    cp /etc/apt/sources.list /etc/apt/sources.list_$DATA
    #sed -i 's/'$VERSION_DEBIAN' main/'$VERSION_DEBIAN' main non-free contrib/g' /etc/apt/sources.list
    #sed -i 's/updates main/updates main non-free contrib/g' /etc/apt/sources.list

    ## Apenas descomente as linhas abaixo caso nao tenha conseguindo os links basicos do repositorio, normalmente na instalação:
    #echo 'deb http://deb.debian.org/debian/ '$VERSION_DEBIAN' main non-free contrib' >> /etc/apt/sources.list
    #echo 'deb-src http://deb.debian.org/debian/ '$VERSION_DEBIAN' main non-free contrib' >> /etc/apt/sources.list
    #echo '' >> /etc/apt/sources.list
    #echo 'deb http://security.debian.org/debian-security '$VERSION_DEBIAN'/updates main contrib non-free' >> /etc/apt/sources.list
    #echo 'deb-src http://security.debian.org/debian-security '$VERSION_DEBIAN'/updates main contrib non-free' >> /etc/apt/sources.list
    #echo '' >> /etc/apt/sources.list
    #echo "# buster-updates, previously known as 'volatile'" >> /etc/apt/sources.list
    #echo 'deb http://deb.debian.org/debian/ '$VERSION_DEBIAN'-updates main contrib non-free' >> /etc/apt/sources.list
    #echo 'deb-src http://deb.debian.org/debian/ '$VERSION_DEBIAN'-updates main contrib non-free' >> /etc/apt/sources.list
    #echo '' >> /etc/apt/sources.list
    
    ####################
    ## Backports - Para funcionar a instalação do Handbrake
    ####################
    echo 'deb http://ftp.debian.org/debian '$VERSION_DEBIAN'-backports main' >> /etc/apt/sources.list

    ####################
    ## A partir desse ponto são não oficiais e outros:
    ####################
    #echo '' >> /etc/apt/sources.list
    #echo '#---------------------------------------#' >> /etc/apt/sources.list
    #echo '# UNOFFICIAL  REPOS' >> /etc/apt/sources.list
    #echo '#---------------------------------------#' >> /etc/apt/sources.list
    #echo '' >> /etc/apt/sources.list
    #echo '### Caso precise adicionar alguma Keys (NO_PUBKEY), basta executar o comando abaixo (Ex. de NO_PUBKEY A040830F7FAC5991):' >> /etc/apt/sources.list
    #echo '# apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys A040830F7FAC5991'>> /etc/apt/sources.list
    #echo '' >> /etc/apt/sources.list
    #echo '### Caso de Erros: ' >> /etc/apt/sources.list
    #echo '# dpkg --remove -force --force-remove-reinstreq NOME_DO_PACOTE_VAI_AQUI' >> /etc/apt/sources.list
    #echo '# apt-get --fix-broken install'  >> /etc/apt/sources.list
    #echo '# apt-get clean.'  >> /etc/apt/sources.list
    #echo '# apt-get install -f'  >> /etc/apt/sources.list
    #echo '# dpkg --configure -a'  >> /etc/apt/sources.list
    #echo '# rm /var/lib/apt/lists/* -vf'  >> /etc/apt/sources.list
    #echo '# apt-get update'  >> /etc/apt/sources.list
    #echo '# apt-get clean.'  >> /etc/apt/sources.list
    #echo '' >> /etc/apt/sources.list
    #echo '### Repositorios da proxima versao Debian Sid/Unstable:' >> /etc/apt/sources.list
    #echo '# Util para instalacao do Remmina, dpkg-dev, etc...' >> /etc/apt/sources.list
    #echo '# deb http://ftp.us.debian.org/debian/ sid main contrib non-free' >> /etc/apt/sources.list
    #echo '# deb http://ftp.us.debian.org/debian/ unstable main contrib non-free' >> /etc/apt/sources.list
    #echo '# deb http://deb.debian.org/debian/ unstable main non-free contrib' >> /etc/apt/sources.list
    #echo '' >> /etc/apt/sources.list

    ## Para multimedia na versao estavel
    #echo '' >> /etc/apt/sources.list
    
    ####################
    ## Caso precise adicionar alguma Keys (NO_PUBKEY - Ex. de NO_PUBKEY 5C808C2B65558117),
    ## basta executar o comando apt-key, conforme abaixo
    ####################
    #apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys 5C808C2B65558117
fi

####################
## Repositorio Docker
####################
if [ $INSTALL_DOCKER == 1 ]; then
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
fi
####################
## Repositorio Signal
####################
if [ $INSTALL_SIGNAL == 1 ]; then
    curl -s https://updates.signal.org/desktop/apt/keys.asc | sudo apt-key add -
    echo "deb [arch=amd64] https://updates.signal.org/desktop/apt xenial main" | sudo tee -a /etc/apt/sources.list.d/signal-xenial.list
fi
####################
## Repositório Virtualbox
## https://linuxdicasesuporte.blogspot.com/2019/04/virtualbox-no-debian-10-buster.html
####################
if [ $INSTALL_VIRTUAL_BOX == 1 ]; then
    echo "deb [arch=amd64] http://download.virtualbox.org/virtualbox/debian bionic contrib" > /etc/apt/sources.list.d/virtualbox.list
    wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | apt-key add -
fi
####################
## Repositorio Visual Code
####################
if [ $INSTALL_VISUAL_CODE == 1 ]; then
    curl -sSL https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
    echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" | sudo tee /etc/apt/sources.list.d/vscode.list
fi

## Tudo adicionado - Atualizar repositorio:
apt-get update

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

## Converter e copiar arquivos de vídeos
if [ $INSTALL_HAND_BRAKE == 1 ]; then
    apt-get -y install handbrake handbrake-cli
fi
## Alternativa ao VLC
#apt-get -y install winff

apt-get -y install libgtop2-common libgtop2-dev
apt-get -y install gstreamer1.0-vaapi

## Editor de vídeo (Pacote não encontrado)
#apt-get -y install avidemux

## Gravar o Desktop - Record my Desktop foi substituido por SimpleScreenRecorder
if [ $INSTALL_DESKTOP_RECORD == 1 ]; then
    #apt-get -y install recordmydesktop
    apt-get -y install simplescreenrecorder
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

    wget http://code.google.com/p/qwbfs/downloads/detail?name=$FILE_QWBFS&can=2&q=
    apt-get -y install build-essential
    apt-get -y install libqt4-core libqt4-dev libqt4-gui libqt4-sql
    apt-get install libudev-dev
    
    qmake PREFIX=/usr/local
    make
    make install
    
    ## Não funciona mais - Pacote não existe
    #apt-get -y install qwbfsmanager 
fi

####################
## VLC e Chromecast (VLC já está preparado para o Chromecast e):
## https://linuxkamarada.com/pt/2020/04/03/transmitindo-do-vlc-para-a-tv-com-o-chromecast/#.YVc5dIDMLMU
####################
apt-get -y install vlc
## Instalacao Antiga para funcionar:
#add-apt-repository ppa:videolan/stable-daily
#apt-get install ffmpeg npm gstreamer1.0-plugins-{base,good,bad,ugly}
#apt-get install chrome-gnome-shell

####################
# MKChromecast - Envio de video e audios para o chromecast a partir do terminal
# https://sempreupdate.com.br/instalar-mkchromecast-no-ubuntu-transmitir-videos-do-ubuntu-para-chromecast/
####################
if [ $INSTALL_CHROMECAST == 1 ]; then
    apt-get -y install mkchromecast
    ####################
    ## Teste, abrindo o terminadl e digitando:
    ####################
    #mkchromecast --source-url http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4 -c mp4 --volume --video
    #mkchromecast -y https://www.youtube.com/watch?v=UKJyJkoxMh4  --video
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
    wget https://dl.google.com/linux/direct/$FILE_CHROME
fi
dpkg -i $FILE_CHROME
rm $FILE_CHROME

####################
## Instalando Signal:
## https://signal.org/pt_BR/download/
####################
if [ $INSTALL_SIGNAL == 1 ]; then
    apt install signal-desktop
fi
####################
## Instalando Telegram:
## https://snapcraft.io/install/telegram-desktop/debian
## https://www.linuxcapable.com/how-to-install-telegram-on-debian-11-bullseye/
## última versão, senão precisa atualizar:
## https://www.maketecheasier.com/install-telegram-desktop-app-linux/
####################
if [ $INSTALL_TELEGRAM == 1 ]; then
    wget -O $FILE_TELEGRAM https://telegram.org/dl/desktop/linux 
    tar -xJvf $FILE_TELEGRAM
    mv Telegram /opt/telegram
    ln -sf /opt/telegram/Telegram /usr/bin/telegram
    rm $FILE_TELEGRAM
    ## Instalacao Antiga:
    #apt -y install telegram-desktop
    ## Pelo Snap
    #snap install telegram-desktop
    ## Para remover
    #snap remove telegram-desktop
    
    ####################
    ## instalacao fica em /opt/telegram
    ## Para abrir execute, na area do usuário gráfico, o comando: telegram
    ## Crie um intem no Menu Name: "Telegram ", comando: /usr/bin/telegram Comment: "Telegram"
    
fi
####################
## Instalando Zoom:
## https://support.zoom.us/hc/pt-br/articles/204206269-Como-instalar-ou-atualizar-o-Zoom-no-Linux
####################
if [ $INSTALL_ZOOM == 1 ]; then
    apt -y install gdebi
    if [ ! -e $FILE_ZOOM ]; then 
        wget https://zoom.us/client/latest/$FILE_ZOOM
    fi
    apt -y install ./$FILE_ZOOM
    rm $FILE_ZOOM

    ## Para remover
    #apt remove zoom
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
apt-get -y install gparted
apt-get -y install forensics-extra-gui
apt-get -y install rsync

## Para manipular Sistema de Arquivo NFST
apt-get -y install udftools

if [ $INSTALL_WIRESHARK == 1 ]; then
    apt-get -y install wireshark
fi

####################
## Desenvolvimento:
####################
apt-get -y install git composer
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

## Python
apt-get -y install python3-pip python3-venv virtualenv python-setuptools rrdtool python3-sphinx
apt-get -y install python3-mysqldb
apt-get -y install libcanberra-gtk-module libcanberra-gtk3-module 
apt-get -y install cmake cmake-gui build-essential checkinstall autoconf 
apt-get -y install libtool libcunit1-dev nettle-dev libyaml-dev libuv1-dev libssl-dev
## Python 2 e outros Ambientes Virtuais
#apt-get -y python-mysqldb python-glade2
#apt-get -y install python-gtk2 python-configobj python-gtk2 python-sphinx
#apt-get -y poetry 
## Pyenv (https://github.com/pyenv/pyenv/wiki)
apt-get -y install --no-install-recommends make build-essential libssl-dev zlib1g-dev 
apt-get -y install libbz2-dev libreadline-dev libsqlite3-dev llvm libncurses5-dev 
apt-get -y install xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

## Bibliotecas python:
pip3 install mysql-connector mysql-connector-python numpy panda lambda
## Não usando Python2
#pip install mysql-connector mysql-connector-python numpy panda lambda

####################
## Virtme - Para trabalhar com o kernel do Linux
## https://github.com/amluto/virtme
## https://www.collabora.com/news-and-blog/blog/2018/09/18/virtme-the-kernel-developers-best-friend/
####################
pip3 install git+https://github.com/ezequielgarcia/virtme.git

## PHP 7
if [ $INSTALL_PHP == 1 ]; then
    apt -y install php7.4 php7.4-mysql php-curl phpunit
    apt -y install ghostscript
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
    apt-get -y install virtualbox-6.0
    ## Instalacao Antiga:
    #apt install dkms linux-headers-$(uname -r) virtualbox-6.0
    ####################
    ## Para abrir o Virtual Box, digite o comando: virtualbox
    ####################
fi

####################
## Instalando Team Viewer
## https://linuxize.com/post/how-to-install-teamviewer-on-debian-9/ 
####################
if [ $INSTALL_TEAM == 1 ]; then
    if [ ! -e $FILE_TEAM ]; then 
        wget https://download.teamviewer.com/download/linux/$FILE_TEAM
    fi
    apt-get -y install ./$FILE_TEAM
fi

####################
## Instalando Nomachine
## https://www.nomachine.com/download/download&id=6
####################
if [ $INSTALL_NOMACHINE == 1 ]; then
    if [ ! -e $FILE_NOMACHINE ]; then 
        wget https://download.nomachine.com/6.9/Linux/$FILE_NOMACHINE
    fi
    dpkg -i $FILE_NOMACHINE
fi

####################
## Instalando Visual Studio Code (VSCode)
####################
if [ $INSTALL_VISUAL_CODE == 1 ]; then
    apt-get -y install code
fi

####################
## Instalando Pycham
####################
if [ $INSTALL_PYCHARM == 1 ]; then
    wget https://download.jetbrains.com/python/$FILE_PYCHARM
    tar xzf pycharm-*.tar.gz -C /opt/
    wget https://img1.gratispng.com/20180412/dqw/kisspng-pycharm-integrated-development-environment-python-idea-5acfabf6d9ea03.3275523415235594148926.jpg -P /opt/pycharm-community-2021.2.3/
    mv /opt/pycharm-community-2021.2.3/kisspng-pycharm-integrated-development-environment-python-idea-5acfabf6d9ea03.3275523415235594148926.jpg /opt/pycharm-community-2021.2.3/logo.jpg
    ln -s /opt/pycharm-community-2021.2.3/bin/pycharm.sh /bin/pycharm
    rm $FILE_PYCHARM
    ####################
    ## instalacao fica em /opt/pycharm-community-*/bin/pycharm.sh
    ## Para abrir o pycharm execute, na area do usuário gráfico, o comando: pycharm
    ## Crie um intem no Menu Name: "Pycharm ", comando: /bin/pycharm Comment: "Pycharm Community (2.3)"
    ## utilize a imagem de logo.jpg que foi baixada no dir /opt/pycharm-community-2021.2.3/
    ####################
    #su $USER_ADM
    #pycharm
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
    systemctl status docker
    apt-cache madison docker-ce
    
    ## Teste
    #echo 'Testando o Docker - comando: docker run --rm -it  --name test alpine:latest /bin/sh'
    #docker run --rm -it  --name test alpine:latest /bin/sh
    
    ## Instalacao Antiga ou outras versoes docker:
    ## Determine a versão
    #apt-get -y install docker-ce=5:20.10.10~3-0~debian-bullseye docker-ce-cli=5:20.10.10~3-0~debian-bullseye containerd.io

    #curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    #chmod +x /usr/local/bin/docker-compose
    #ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
fi

####################
## Apache + Mysql + PHP
## https://blog.remontti.com.br/3006
####################
if [ $INSTALL_WWW == 1 ]; then
    apt-get -y install apache2
    ## O diretório web apontarah para o desenvolvimento
    rm -rf $DIR_WWW/html
    ln -s $DIR_DEV_HTML $DIR_WWW/html
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

    ####################
    ## Outras Bibliotecas PHP
    ####################
    apt -y install libapache2-mod-php php php-mysql php-cli php-pear php-gmp php-gd php-bcmath php-mbstring php-xml php-zip
    ## Teste se o PHP funcionou
    #echo '<?php phpinfo(); ?>' > $DIR_WWW/html/phpinfo.php
    #chown $USER_ADM:$USER_ADM $DIR_WWW/html/phpinfo.php
fi

####################
## Workbench
## Instalando o Workbench
####################
if [ $INSTALL_WB == 1 ]; then
    wget https://downloads.mysql.com/archives/get/p/8/file/$FILE_WB 
    dpkg -i $FILE_WB
    apt -f install
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

####################
## Removendo Programas
####################
## Retirando o Thunderbird
apt-get -y remove thunderbird
## Retirando o Evolution
apt-get -y remove evolution
## Remover pacotes que não precisem mais
apt autoremove
## Caso algum tenha ficado quebrado
apt --fix-broken install

####################
## Acertando permissões e Grupos
## Colocando nos grupos
####################
if [ $ALTERAR_GROUP == 1 ]; then
    echo 'Salvando cópia do arquivo group em group.original'
    cp /etc/group /etc/group.original

    usermod -aG adm $USER_ADM
    usermod -aG lp $USER_ADM
    usermod -aG sambashare $USER_ADM
    usermod -aG libvirt-qemu $USER_ADM
    usermod -aG libvirt $USER_ADM

    if [ $INSTALL_WWW == 1 ]; then
        usermod -aG www-data $USER_ADM
        usermod -aG $USER_ADM www-data
    fi
    if [ $INSTALL_MYSQL == 1 ]; then
        usermod -aG mysql $USER_ADM
        usermod -aG $USER_ADM mysql
    fi
    if [ $INSTALL_DOCKER == 1 ]; then
        usermod -aG docker $USER_ADM
        usermod -aG $USER_ADM docker
    fi
    if [ $INSTALL_VIRTUAL_BOX == 1 ]; then
        usermod -aG vboxusers $USER_ADM
        usermod -aG $USER_ADM vboxusers
    fi
    if [ $INSTALL_WIRESHARK == 1 ]; then
        usermod -aG wireshark $USER_ADM
    fi
fi

####################
## Instalando Dropbox
####################
su $USER_ADM
wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
~/.dropbox-dist/dropboxd

####################
## AWS - Para utilizacao e acesso do Ludopedio
## https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html#cliv2-linux-install
## https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html#install-plugin-linux
####################
if [ $INSTALL_AWS == 1 ]; then
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

ls -al /etc/apt/
echo 'Verifique se eh necessario apagar um ou mais arquivos sources.list_(DATA), gerado(s) automaticamente'

####################
## Instalar GNOME Extension
####################
echo 'Instalações do GNOME Extension, acesse:'
echo 'https://extensions.gnome.org/extension/36/lock-keys/'
echo 'https://extensions.gnome.org/extension/97/coverflow-alt-tab/'
echo 'https://extensions.gnome.org/extension/120/system-monitor/'
echo 'https://extensions.gnome.org/extension/750/openweather/'

echo 'https://extensions.gnome.org/extension/1266/transparent-top-bar/'
echo 'https://extensions.gnome.org/extension/1446/transparent-window-moving/'
echo 'https://extensions.gnome.org/extension/1080/transparent-notification/'

echo 'Já vem com o Linux:'
echo 'https://extensions.gnome.org/extension/7/removable-drive-menu/'
echo 'https://extensions.gnome.org/extension/6/applications-menu/'
echo 'https://extensions.gnome.org/extension/8/places-status-indicator/'
echo 'https://extensions.gnome.org/extension/1073/transparent-osd/'
echo '--------------------------------------------'

## Corretor Gramatical LibreOffice usando Vero
## https://pt-br.libreoffice.org/projetos/vero
## https://sempreupdate.com.br/como-instalar-o-corretor-ortografico-no-libreoffice/
####################
wget -O $DIR_USER_ADM/Download/$FILE_VEROBR https://pt-br.libreoffice.org/assets/Uploads/PT-BR-Documents/VERO/$FILE_VEROBR
## Caso instalar o corretor ortográfico
echo 'Incluir o corretor Gramatical BR Office:'
echo 'Extensão no Write: Ferramentas > Gerenciador de extensão > Adicionar o arquivo '$DIR_USER_ADM'/Download/'$FILE_VEROBR

echo 'Se desejar reiniciar digite o comando: sudo shutdown -r now'
