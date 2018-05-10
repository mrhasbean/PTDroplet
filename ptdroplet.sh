#!/bin/bash

prompt_confirm() {
  while true; do
    read -r -n 1 -p "${1:-Continue?} [y/n]: " REPLY
    case $REPLY in
      [yY]) echo ; return 0 ;;
      [nN]) echo ; return 1 ;;
      *) printf " \033[31m %s \n\033[0m" "invalid input"
    esac 
  done  
}

clear
echo "################################################################"
echo "#            https://github.com/mrhasbean/PTDroplet            #"
echo "#                                                              #"
echo "# We will go though the proccess of setting up a ProfitTrailer #"
echo "#                        bot server.                           #"
echo "#                                                              #"
echo "################################################################"
echo
prompt_confirm || exit 0
clear

# installation requires root access
echo Stage 1: Checking root access
echo
sleep 2
if [ "x$(id -u)" != 'x0' ]; then
    echo 'Error: this script can only be executed by root'
    exit 1
fi
echo
echo Stage 1: Complete
sleep 2

# creates SWAP on the server
echo Stage 2: Creating SWAP space
echo
sleep 2
sudo fallocate -l 1024M /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo echo "/swapfile   none    swap    sw    0   0" >> /etc/fstab
sudo sysctl vm.swappiness=10
sudo echo "vm.swappiness=10" >> /etc/sysctl.conf
sudo sysctl vm.vfs_cache_pressure=50
sudo echo "vm.vfs_cache_pressure=50" >> /etc/sysctl.conf
echo
echo Stage 2: Complete
sleep 5
clear

# change time zone at your new server
echo Stage 3: Change server timezone & locale
echo
sleep 2
dpkg-reconfigure tzdata
export LC_ALL=en_US.UTF-8
export LANG="en_US.UTF-8"
export LANGUAGE=en_US.UTF-8
echo 'LC_ALL=en_US.UTF-8' >> /etc/environment
echo 'LANG=en_US.UTF-8' >> /etc/environment
echo 'LANGUAGE=en_US.UTF-8' >> /etc/environment
dpkg-reconfigure locales
echo
echo Stage 3: Complete
sleep 5
clear

# update server software
echo Stage 4: Updating software
echo
sleep 2
apt-get -y update
echo
echo Stage 4: Complete
sleep 5
clear

# install a few useful tools
echo Stage 5: Installing archive tools
echo
sleep 2
apt-get -y install zip
apt-get -y install unzip
apt-get -y install p7zip-full
echo
echo Stage 5: Complete
sleep 5
clear

# install java
echo Stage 6: Installing Java
echo
sleep 2
apt-get -y install default-jdk
echo
echo Stage 6: Complete
sleep 5
clear

# install nodejs and link to /nodejs and /node directories
echo Stage 7: Installing nodejs
echo
sleep 2
apt-get -y install nodejs
ln -s /usr/bin/nodejs /usr/bin/node
echo
echo Stage 7: Complete
sleep 5
clear

# install npm and use npm to install pm2
echo Stage 8: Installing npm and pm2
echo
sleep 2
apt-get -y install npm
npm install pm2@latest -g
echo
echo Stage 8: Complete
sleep 5
clear

# create pt directory structure
echo Stage 9: Creating base PT folder structure
echo
sleep 2
cd /var/opt
mkdir pt
cd pt
mkdir releases

# create bot directory
echo Please enter a name for this bot. For best compatibility, use only lower case a-z and NO spaces. eg. myfirstbot
read -p 'Bot Name: ' botname
mkdir $botname
cd $botname
echo
echo Stage 9: Complete
sleep 5
clear

# download latest ProfitTrailer and extract to bot directory
echo Stage 10: Downloading latest ProfitTrailer release
echo
sleep 2
wget https://github.com/$(wget https://github.com/taniman/profit-trailer/releases/latest -O - | egrep '/.*/.*/.*zip' -o)
unzip *zip
mv *zip ../releases
mv ProfitTrailer* ProfitTrailer
cd ProfitTrailer
mv * ..
cd ..
rm -rf ProfitTrailer
chmod +x ProfitTrailer.jar
echo
echo Stage 10: Complete
sleep 5

clear
echo Installation complete. You must now reboot to finalise the installation. At the prompt below, simply type:
echo "    reboot"
echo
echo After rebooting, please proceed to edit your application.properties and settings files.
echo See https://wiki.profittrailer.com/doku.php?id=mandatory_settings for details.
echo
echo After you have completed the Mandatory Settings, launch ProfitTrailer. At the prompt, type:
echo "    cd /var/opt/pt/$botname"
echo "    pm2 start pm2-ProfitTrailer.json"
echo
echo You can then monitor the bot using the pm2 Dashboard by typing:
echo "    pm2 dash"
echo
echo Happy Profit Trailing!

# END
