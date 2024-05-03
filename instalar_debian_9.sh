#!/bin/bash
#Vornei Augusto Grella - Instalacao de programas para o Debian 9
#Esse programa deve ser executado como root e pode ser executado mais de uma vez
#Porem os comandos SED foram comentados e devem ser executados manualmente
#senao ira acarretar em problemas em arquivos do sudoers e sources.list, por exemplo
#por isso essas linhas foram comentadas e recomendo no caso do sudoers, conferir se
#o SED funcionou
#Importante: nao esqueca de colocar o usuario administrador (ex: vagrella), nos groups desejados

DATA=`date +%Y%m%d%Y_%H%M%S`
USER_ADM='vagrella'

#sed -i 's/adm:x:4:/adm:x:4:vagrella/' /etc/group
#sed -i 's/lp:x:7:/lp:x:7:vagrella/' /etc/group
#sed -i 's/www-data:x:33:/www-data:x:33:vagrella/' /etc/group
#sed -i 's/vagrella:x:1000:/vagrella:x:1000:www-data,docker,wireshark,libvirt,libvirt-qemu/' /etc/group
#sed -i 's/docker:x:999:/docker:x:999:vagrella/' /etc/group
#sed -i 's/wireshark:x:125:/wireshark:x:125:vagrella/' /etc/group
#sed -i 's/libvirt:x:127:/libvirt:x:127:vagrella/' /etc/group
#sed -i 's/libvirt-qemu:x:64055:/libvirt-qemu:x:64055:libvirt-qemu,vagrella/' /etc/group
#sed -i 's/vboxusers:x:128:/vboxusers:x:128:vagrella/' /etc/group
#sed -i 's/sambashare:x:129:/sambashare:x:129:vagrella/' /etc/group

####################
## Preparando repositorios
####################
cp /etc/apt/sources.list /etc/apt/sources.list_$DATA
#sed  -i 's/stretch main/stretch main non-free contrib/g' /etc/apt/sources.list
#sed  -i 's/updates main/updates main non-free contrib/g' /etc/apt/sources.list

DIR_PROGRAM=/home/program/
mkdir -p $DIR_PROGRAM
chown -R $USER_ADM:$USER_ADM $DIR_PROGRAM

####################
## Adicionando ao sudoers
####################
#chmod u+w /etc/sudoers
#sed -i 's/rootALL=(ALL:ALL) ALL/rootALL=(ALL:ALL) ALL\/nvagrella ALL=(ALL:ALL) ALL/' /etc/sudoers
#chmod u-w /etc/sudoers

####################
## Instalando Pacotes essenciais
####################
apt-get -y install net-tools dnsutils nmap 
apt-get -y install curl dirmngr software-properties-common apt-transport-https ca-certificates gnupg2

####################
## Adicionando ao repositorio
####################
echo '' >> /etc/apt/sources.list
echo '#---------------------------------------#' >> /etc/apt/sources.list
echo '#      UNOFFICIAL  REPOS' >> /etc/apt/sources.list
echo '#---------------------------------------#' >> /etc/apt/sources.list
echo '' >> /etc/apt/sources.list
echo '### Repositorio da proxima versao Debian Buster:' >> /etc/apt/sources.list
echo '# Apenas para instalacao do Remmina, dpkg-dev' >> /etc/apt/sources.list
echo '# deb http://ftp.us.debian.org/debian/ buster main contrib non-free' >> /etc/apt/sources.list
echo '' >> /etc/apt/sources.list
## Para multimedia na versao estavel
echo "deb [arch=amd64,armel,armhf,i386] http://www.deb-multimedia.org stable main non-free" >> /etc/apt/sources.list
### Caso precise adicionar alguma Keys (NO_PUBKEY), basta executar o comando abaixo (Ex. de NO_PUBKEY 5C808C2B65558117):
apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys 5C808C2B65558117
echo '' >> /etc/apt/sources.list
## Para instalar o Virtualbox
echo "deb http://download.virtualbox.org/virtualbox/debian stretch contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -

## Para Instalar Sublimetext
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list

## Para instalar Visual Code
curl -sSL https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" | sudo tee /etc/apt/sources.list.d/vscode.list

## Para instalar Docker
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
apt-key fingerprint 0EBFCD88
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian stretch stable"

## Para instalar Insomnia: https://support.insomnia.rest/article/23-installation
echo "deb https://dl.bintray.com/getinsomnia/Insomnia /" | sudo tee -a /etc/apt/sources.list.d/insomnia.list
wget --quiet -O - https://insomnia.rest/keys/debian-public.key.asc \
    | sudo apt-key add -

## Tudo adicionado - Atualizar repositorio:
apt-get update

####################
## Iniciando Instalacoes
####################
apt-get -y install vim git
apt-get -y install alacarte openssh-server gparted seahorse-nautilus
apt-get -y install firmware-linux-nonfree firmware-realtek
apt-get -y install sound-juicer soundconverter gtkpod nautilus-image-manipulator qwbfsmanager 
apt-get -y install libgtop2-common libgtop2-dev
apt-get -y install forensics-extra-gui
## Para funcionar o OpenXenManager
apt-get -y install python-gtk2 glade python-gtk-vnc python-glade2 python-configobj python-setuptools python-pip rrdtool
apt-get -y install python3-pip 
apt-get -y install putty gksu samba nautilus-share
apt-get -y install libcanberra-gtk-module libcanberra-gtk3-module 
apt-get -y install cmake cmake-gui build-essential checkinstall autoconf libtool python-sphinx libcunit1-dev nettle-dev libyaml-dev libuv1-dev libssl-dev

####################
## Instalando Ferramentas:
####################
apt-get -y install apache2-utils insomnia
####################
## para usar o ab
## Ex: comando: ab -n 10000 -c 50  -k google.com.br/
## = 10 mil requisicoes e 50 usuarios, 200 requisicoes por usuario
####################

apt-get -y install mysql-client
apt-get -y install meld nautilus-compare
apt-get -y install wireshark
apt-get -y install virt-manager
apt-get -y install sublime-text
apt-get -y install virtualbox-6.0
#Para abrir o Virtual Box, digite o comando: virtualbox

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
FILE_TV='teamviewer_amd64.deb'
if [ ! -e $FILE_TV ]; then 
	wget wget https://download.teamviewer.com/download/linux/$FILE_TV
fi
apt  -y install ./teamviewer_amd64.deb

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
## Instalando OpenXenManager
####################
pip install configobj raven
DIR_XEN=$DIR_PROGRAM/openxenmanager/

cd $DIR_PROGRAM
git clone https://github.com/OpenXenManager/openxenmanager.git

chown -R $USER_ADM:$USER_ADM $DIR_XEN

echo '#!/bin/sh 
cd /home/program/openxenmanager/
./openxenmanager' > /usr/bin/xenmanager
chmod 755 /usr/bin/xenmanager
#Para iniciar o programa execute o comando: xenmanager

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
## ttp://support.lexmark.com/index?page=driverSupport&locale=PT&userlocale=PT_BR
## Nao eh possivel fazer download por wget
####################
apt-get -y install cups hplip
DIR_PROGRAMAS=/home/$USER_ADM/Downloads/programas/
DIR_IMPRESSORA=$DIR_PROGRAMAS/lexmark/
mkdir -p $DIR_IMPRESSORA
chown -R $USER_ADM:$USER_ADM $DIR_PROGRAMAS
cd $DIR_IMPRESSORA
tar -xzvf Lexmark-ADQ-PPD-Files.tar.Z
cd Lexmark-ADQ-PPD-Files/ppd_files/
./install_ppd.sh
rm -rf PPD-Files-LMACQ_ubuntu_12.tar.Z
rf -rf ppd_files/

####################
## Instalando Dropbox
####################
apt-get -y install nautilus-dropbox

#su $USER_ADM
#dropbox start -i

####################
## Instalando bibliotecas python:
####################
pip install mysql-connector numpy lambda
pip3 install mysql-connector numpy lambda

ls -al /etc/apt/
echo 'Verifique se eh necessario apagar um ou mais arquivos sources.list_(DATA), gerado automatico'



