#!/bin/bash
#Vornei Augusto Grella - Instalacao de programas para o Debian 10 Buster
#Esse programa deve ser executado como root e pode ser executado mais de uma vez
#Porem os comandos SED foram comentados e devem ser executados manualmente
#senao ira acarretar em problemas em arquivos do sudoers e sources.list, por exemplo
#por isso essas linhas foram comentadas e recomendo no caso do sudoers, conferir se
#o SED funcionou
#Importante: nao esqueca de colocar o usuario administrador (ex: vagrella), nos groups desejados

DATA=`date +%Y%m%d%Y_%H%M%S`
USER_ADM='vagrella'
VERSION_DEBIAN='buster'

####################
## Preparando repositorios
####################
cp /etc/apt/sources.list /etc/apt/sources.list_$DATA
#sed -i 's/'$VERSION_DEBIAN' main/'$VERSION_DEBIAN' main non-free contrib/g' /etc/apt/sources.list
#sed -i 's/updates main/updates main non-free contrib/g' /etc/apt/sources.list

cp /etc/bash.bashrc /etc/apt/bash.bashrc_$DATA
echo '### Vornei'  >> /etc/bash.bashrc
echo "alias ls='ls --color=auto'" >> /etc/bash.bashrc
echo "alias vi='vi -c \"syntax on\" -c \"set number \"'" >> /etc/bash.bashrc
echo '' >> /etc/bash.bashrc
echo '#export MAVEN_HOME="/home/program/maven/apache-maven-2.2.1/"' >> /etc/bash.bashrc
echo '# Set o PATH com o MAVEN_HOME' >> /etc/bash.bashrc
echo '#export PATH="$MAVEN_HOME/bin:$PATH"' >> /etc/bash.bashrc

echo "alias manage='python "'$VIRTUAL_ENV/manage.py'"'" >> /etc/bash.bashrc

DIR_PROGRAM=/home/program/
if [ ! -d "$DIR_PROGRAM"]; then
    mkdir -p $DIR_JVM;
fi

chown -R $USER_ADM:$USER_ADM $DIR_PROGRAM

####################
## Adicionando ao sudoers
## Não funcionou no momento, pois existe um TAB
####################
#chmod u+w /etc/sudoers
#sed -i 's/root    ALL=(ALL:ALL) ALL/root    ALL=(ALL:ALL) ALL\/n'$USER_ADM' ALL=(ALL:ALL) ALL/' /etc/sudoers
#chmod u-w /etc/sudoers


####################
## Adicionando ao repositorio
####################

## Apenas descomente as linhas abaixo caso nao tenha conseguindo os links basicos do repositorio, normalmente na instalação
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
## Instalando Pacotes essenciais
####################
apt-get update
apt-get -y install wget curl dirmngr software-properties-common apt-transport-https ca-certificates gnupg2

#Apartir desse ponto são não oficiais e outros
echo '' >> /etc/apt/sources.list
echo '#---------------------------------------#' >> /etc/apt/sources.list
echo '# UNOFFICIAL  REPOS' >> /etc/apt/sources.list
echo '#---------------------------------------#' >> /etc/apt/sources.list
echo '' >> /etc/apt/sources.list
echo '### Caso precise adicionar alguma Keys (NO_PUBKEY), basta executar o comando abaixo (Ex. de NO_PUBKEY A040830F7FAC5991):' >> /etc/apt/sources.list
echo '# apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys A040830F7FAC5991'  >> /etc/apt/sources.list
echo '' >> /etc/apt/sources.list
echo '### Caso de Erros: ' >> /etc/apt/sources.list
echo '# dpkg --remove -force --force-remove-reinstreq NOME_DO_PACOTE_VAI_AQUI'  >> /etc/apt/sources.list
echo ' apt-get --fix-broken install'  >> /etc/apt/sources.list
echo ' apt-get clean.'  >> /etc/apt/sources.list
echo ' apt-get install -f'  >> /etc/apt/sources.list
echo ' dpkg --configure -a'  >> /etc/apt/sources.list
echo ' rm /var/lib/apt/lists/* -vf'  >> /etc/apt/sources.list
echo ' apt-get update'  >> /etc/apt/sources.list
echo ' apt-get clean.'  >> /etc/apt/sources.list
echo '' >> /etc/apt/sources.list
echo '### Repositorios da proxima versao Debian Sid/Unstable:' >> /etc/apt/sources.list
echo '# Util para instalacao do Remmina, dpkg-dev, etc...' >> /etc/apt/sources.list
echo '# deb http://ftp.us.debian.org/debian/ sid main contrib non-free' >> /etc/apt/sources.list
echo '# deb http://ftp.us.debian.org/debian/ unstable main contrib non-free' >> /etc/apt/sources.list
echo '# deb http://deb.debian.org/debian/ unstable main non-free contrib' >> /etc/apt/sources.list
echo '' >> /etc/apt/sources.list

## Para multimedia na versao estavel
echo '### Pacotes Multimidia:' >> /etc/apt/sources.list
echo "deb [arch=amd64,armel,armhf,i386] http://www.deb-multimedia.org stable main non-free" >> /etc/apt/sources.list
echo "deb http://deb.debian.org/debian/ buster-proposed-updates main non-free contrib" >> /etc/apt/sources.list
echo '' >> /etc/apt/sources.list
### Caso precise adicionar alguma Keys (NO_PUBKEY), basta executar o comando abaixo (Ex. de NO_PUBKEY 5C808C2B65558117):
apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys 5C808C2B65558117

## Para instalar o Virtualbox
#https://linuxdicasesuporte.blogspot.com/2019/04/virtualbox-no-debian-10-buster.html
echo "deb [arch=amd64] http://download.virtualbox.org/virtualbox/debian bionic contrib" > /etc/apt/sources.list.d/virtualbox.list
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | apt-key add -
wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | apt-key add -

## Para Instalar Sublimetext
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys F57D4F59BD3DF454

## Para instalar Insomnia: https://support.insomnia.rest/article/23-installation
echo "deb https://dl.bintray.com/getinsomnia/Insomnia /" | sudo tee -a /etc/apt/sources.list.d/insomnia.list
wget --quiet -O - https://insomnia.rest/keys/debian-public.key.asc | sudo apt-key add -
apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys 379CE192D401AB61

## Para instalar Visual Code
curl -sSL https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" | sudo tee /etc/apt/sources.list.d/vscode.list

## Para instalar Docker
#apt-get remove docker docker-engine docker.io containerd runc
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -

apt-key fingerprint 0EBFCD88

## Buster dando erro:
#add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian '$VERSION_DEBIAN' stable"
## Caso essa versão esteja dando errada, tentar a versão anterior a baixo:
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian stretch stable"


## Tudo adicionado - Atualizar repositorio:
apt-get update

####################
## VPN - Unicamp: https://www.ccuec.unicamp.br/ccuec/material_apoio/tutorial_linux_vpn_versoes
####################
apt install openvpn openvpn-systemd-resolved
#Abra o navegador e acesse: https://config.vpn.unicamp.br

####################
## Iniciando Instalacoes
####################
apt-get -y install gnome-control-center
apt-get -y install vim git composer
apt-get -y install net-tools dnsutils nmap traceroute
apt-get -y install alacarte openssh-server gparted seahorse-nautilus sshfs
apt-get -y install firmware-linux-nonfree firmware-realtek
apt-get -y install sound-juicer soundconverter nautilus-image-manipulator nautilus-share
apt-get -y install libgtop2-common libgtop2-dev
apt-get -y install forensics-extra-gui
#O pacote gksu não está disponível, mas é referenciado por outro pacote.
#Isto pode significar que o pacote está faltando, ficou obsoleto ou
#está disponível somente a partir de outra fonte
#apt-get -y install putty gksu samba nautilus-share
apt-get -y install putty samba nautilus-share

apt-get -y install python-gtk2 python-configobj python-setuptools rrdtool python-gtk2
apt-get -y install python-pip python3-pip virtualenv poetry python-mysqldb
apt-get -y install libcanberra-gtk-module libcanberra-gtk3-module 
apt-get -y install cmake cmake-gui build-essential checkinstall autoconf libtool python-sphinx libcunit1-dev nettle-dev libyaml-dev libuv1-dev libssl-dev
apt-get -y install glade python-glade2

#Para manipular Sistema de Arquivo NFST
apt-get -y install udftools

#conexoes remotas
apt-get -y install remmina rdesktop
#Se for servidor de acesso remoto RDP
apt-get -y install xrdp

## LEGAIS: Para Manipular imagens, compartilhar arquivos, cerveja, wii, etc...
apt-get -y install qbrew gtkpod gtk-recordmydesktop apt apt-
## QWBFS ERRO:- Can't open partition:
## Basta verificar o dirve da paticao e dar total privilegio, exemplo se for sdb1, com comando:
## chmod 777 /dev/sdb1
apt-get -y install qwbfsmanager 
##Nao foi o problema dos pacotes abaixo, nao precisa instalar
#build-essential qt4-qmake libssl-dev libqt4-dev libxext-dev libudev-dev 

## Videos e medias:
#apt-get -y install winff

#Retirando o Thunderbird
apt-get -y remove thunderbird

#Pyenv (https://github.com/pyenv/pyenv/wiki)
#apt-get install --no-install-recommends make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev llvm libncurses5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

#NodeJs
apt-get -y install nodejs npm
#Problemas de versão
curl https://www.npmjs.com/install.sh | sudo sh

####################
## Instalando Ferramentas:
####################
apt-get -y install apache2-utils insomnia
####################
## para usar o ab
## Ex: comando: ab -n 10000 -c 50  -k google.com.br/
## = 10 mil requisicoes e 50 usuarios, 200 requisicoes por usuario
####################

apt-get -y install handbrake handbrake-cli handbrake-gtk
apt-get -y install avidemux
apt-get -y install mariadb-client
apt-get -y install meld nautilus-compare
apt-get -y install wireshark
apt-get -y install virt-manager
apt-get -y install sublime-text
apt-get -y install virtualbox-6.0
#Para abrir o Virtual Box, digite o comando: virtualbox

#Matlab: Octave/MATLAB mex generator
apt-get -y install octave mwrap

####################
## AWS: Para utilizacao e acesso do Ludopedio
####################
#https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html#cliv2-linux-install
FILE_AWS=awscli-exe-linux-x86_64.zip
curl "https://awscli.amazonaws.com/$FILE_AWS" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install

#https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html#install-plugin-linux
FILE_AWS=session-manager-plugin.deb
curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/$FILE_AWS" -o "$FILE_AWS"
dpkg -i $FILE_AWS

####################
# Diretorio para montar o ludopedio
# https://www.hiroom2.com/2017/08/04/ubuntu-1604-sshfs-en/
#
# sshfs ludopedio.com.br/usr/share/nginx/html:ec2-user /mnt/ludopedio
####################
#DIR_LUDOPEDIO='/mnt/ludopedio'
#mkdir $DIR_LUDOPEDIO
#chmod g+w $DIR_LUDOPEDIO
#chown root:$USER_ADM $DIR_LUDOPEDIO


####################
# Virtme
####################
pip3 install git+https://github.com/ezequielgarcia/virtme.git

####################
## Instalando Pycham
####################
apt-get -y install snapd
snap install pycharm-community --classic
ln -s /snap/bin/pycharm-community /bin/pycharm-community
####################
## instalacao fica em /snap/bin/pycharm-community
## Para abrir o pycham execute o comando: pycharm-community
####################

####################
## Instalando Google Chrome
####################
FILE_CHROME='google-chrome-stable_current_amd64.deb'
if [ ! -e $FILE_CHROME ]; then 
	wget https://dl.google.com/linux/direct/$FILE_CHROME
fi
dpkg -i google-chrome-stable_current_amd64.deb
apt-get -f install
apt --fix-broken install

####################
## Instalando Team Viewer
## https://linuxize.com/post/how-to-install-teamviewer-on-debian-9/ 
####################
#FILE_REMOTO='teamviewer_amd64.deb'
#if [ ! -e $FILE_REMOTO ]; then 
#    wget https://download.teamviewer.com/download/linux/$FILE_REMOTO
#fi
#apt-get -y install ./$FILE_REMOTO

####################
## Instalando Nomachine
## https://www.nomachine.com/download/download&id=6
####################
FILE_REMOTO='nomachine_6.9.2_1_amd64.deb'
if [ ! -e $FILE_REMOTO ]; then 
    wget https://download.nomachine.com/6.9/Linux/$FILE_REMOTO
fi
dpkg -i $FILE_REMOTO

####################
# MKChromecast - Envio de video e audios para o chromecast a partir do terminal
# https://sempreupdate.com.br/instalar-mkchromecast-no-ubuntu-transmitir-videos-do-ubuntu-para-chromecast/
####################
FILE_ARQ='mkchromecast_0.3.8.1-1_all.deb'
wget https://github.com/muammar/mkchromecast/releases/download/0.3.8.1/$FILE_ARQ
dpkg -i $FILE_ARQ
apt -f install

# Teste, abrindo o terminadl e digitando:
# mkchromecast --source-url http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4 -c mp4 --volume --video
# mkchromecast -y https://www.youtube.com/watch?v=UKJyJkoxMh4  --video

####################
##Instalar Docker e Docker composer
####################
apt-get -y install docker-ce docker-ce-cli containerd.io
curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

####################
## Instalando VisualCode
####################
apt-get -y install code

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

####################
## Impressao: caso não tenha baixado o drive da Lexmark MX711, acesse:
## http://support.lexmark.com/index?page=driverSupport&locale=PT&userlocale=PT_BR
## Nao eh possivel fazer download por wget
####################
apt-get -y install cups hplip
#DIR_PROGRAMAS=/home/$USER_ADM/Downloads/programas/
#DIR_IMPRESSORA=$DIR_PROGRAMAS/lexmark/
#mkdir -p $DIR_IMPRESSORA
#chown -R $USER_ADM:$USER_ADM $DIR_PROGRAMAS
#cd $DIR_IMPRESSORA
#tar -xzvf Lexmark-ADQ-PPD-Files.tar.Z
#cd Lexmark-ADQ-PPD-Files/ppd_files/
#./install_ppd.sh
#rm -rf PPD-Files-LMACQ_ubuntu_12.tar.Z
#rf -rf ppd_files/

####################
## Java - JVM e JRE
####################
FILE_JVM='jre-8u241-linux-x64.tar.gz'
ID_JVM='AutoDL?BundleId=241526_1f5b5a70bf22433b84d0e960903adac8'

DIR_JVM=$DIR_PROGRAM'/jvm'
DIR_JRE=$DIR_JVM'/jre1.8.0_241'

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

####################
## Instalando bibliotecas python:
####################
pip install mysql-connector mysql-connector-python numpy panda lambda
pip3 install mysql-connector mysql-connector-python numpy panda lambda

####################
## Instalando Signal:
## https://signal.org/pt_BR/download/
####################
curl -s https://updates.signal.org/desktop/apt/keys.asc | sudo apt-key add -
echo "deb [arch=amd64] https://updates.signal.org/desktop/apt xenial main" | sudo tee -a /etc/apt/sources.list.d/signal-xenial.list
sudo apt update && sudo apt install signal-desktop

####################
## Instalando OpenXenManager
####################
#pip install configobj raven
#DIR_XEN=$DIR_PROGRAM/openxenmanager/

#cd $DIR_PROGRAM
#git clone https://github.com/OpenXenManager/openxenmanager.git

#chown -R $USER_ADM:$USER_ADM $DIR_XEN

#echo '#!/bin/sh 
#cd /home/program/openxenmanager/
#./openxenmanager' > /usr/bin/xenmanager
#chmod 755 /usr/bin/xenmanager
## Para iniciar o programa execute o comando: xenmanager

####################
## Instalando Dropbox
####################
apt-get -y install nautilus-dropbox

su $USER_ADM
dropbox start -i

####################
## Acertando permissões e Grupos
####################

#Colocando nos grupos
echo 'Salvando cópia do arquivo group em group.original'
cp /etc/group /etc/group.original
sed -i 's/adm:x:4:/adm:x:4:'$USER_ADM'/' /etc/group
sed -i 's/lp:x:7:/lp:x:7:'$USER_ADM'/' /etc/group
sed -i 's/www-data:x:33:/www-data:x:33:'$USER_ADM'/' /etc/group
sed -i 's/'$USER_ADM':x:1000:/'$USER_ADM':x:1000:www-data,docker,wireshark,libvirt,libvirt-qemu/' /etc/group
sed -i 's/docker:x:999:/docker:x:999:'$USER_ADM'/' /etc/group
sed -i 's/wireshark:x:125:/wireshark:x:125:'$USER_ADM'/' /etc/group
sed -i 's/libvirt:x:126:/libvirt:x:126:'$USER_ADM'/' /etc/group
sed -i 's/libvirt-qemu:x:64055:libvirt-qemu/libvirt-qemu:x:64055:libvirt-qemu,'$USER_ADM'/' /etc/group
sed -i 's/vboxusers:x:128:/vboxusers:x:128:'$USER_ADM'/' /etc/group
sed -i 's/sambashare:x:129:/sambashare:x:129:'$USER_ADM'/' /etc/group

ls -al /etc/apt/
echo 'Verifique se eh necessario apagar um ou mais arquivos sources.list_(DATA), gerado(s) automaticamente'

echo 'Depois que rebootar - Instalacao no GNOME Extension, acesse:'
echo 'https://extensions.gnome.org/extension/36/lock-keys/'
echo 'https://extensions.gnome.org/extension/97/coverflow-alt-tab/'
echo 'https://extensions.gnome.org/extension/1446/transparent-window-moving/'
echo 'https://extensions.gnome.org/extension/120/system-monitor/'
echo 'https://extensions.gnome.org/extension/6/applications-menu/'
echo 'https://extensions.gnome.org/extension/750/openweather/'
echo 'https://extensions.gnome.org/extension/8/places-status-indicator/'
echo 'https://extensions.gnome.org/extension/7/removable-drive-menu/'
echo 'https://extensions.gnome.org/extension/1080/transparent-notification/'
echo 'https://extensions.gnome.org/extension/1073/transparent-osd/'
echo 'https://extensions.gnome.org/extension/1266/transparent-top-bar/'
echo '--------------------------------------------'
echo 'Reiniciando...'

####################
## Apache + Mysql + PHP
## https://blog.remontti.com.br/3006
####################

apt-get -y install apache2

## Caso deseje que o diretório web aponte para o desenvolvimento
#cd /var/www/
#rm -rf html
#ln -s /home/dev/html/

#apt -y install mariadb-server mariadb-client

## Colocando Senha de root
#mysql -u root

#USE mysql;
#UPDATE user SET password=PASSWORD('ditongo78') WHERE User='root';
#UPDATE user SET plugin="mysql_native_password";

# Criando um novo usuário
#CREATE USER 'user'@'localhost' IDENTIFIED BY 'teste123';
#GRANT ALL PRIVILEGES ON *.* TO 'user'@'localhost';

#FLUSH PRIVILEGES;
#quit;

#sed -i 's/mysql:x:131:/mysql:x:131:'$USER_ADM'/' /etc/group


# PHP
#apt -y install libapache2-mod-php php php-mysql php-cli php-pear php-gmp php-gd php-bcmath php-mbstring php-curl php-xml php-zip

#echo '<?php phpinfo(); ?>' > /var/www/html/phpinfo.php
#chown  $USER_ADM:$USER_ADM /var/www/html/phpinfo.php


####################
## Workbench
####################
#Instalando o Workbench
$FILE_WB='mysql-workbench-community_8.0.16-1ubuntu18.04_amd64.deb'
wget https://downloads.mysql.com/archives/get/p/8/file/$FILE_WB
dpkg -i $FILE_WB
apt -f install

sleep 5
shutdown -r now


