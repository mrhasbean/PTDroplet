#!/bin/bash
echo
echo
echo "################################################################"
echo "#            https://github.com/mrhasbean/PTDroplet            #"
echo "#                                                              #"
echo "# We will go though the proccess of setting up a ProfitTrailer #"
echo "#                        bot server.                           #"
echo "#                                                              #"
echo "################################################################"
echo

# installation requires root access
echo Checking root access
if [ "x$(id -u)" != 'x0' ]; then
    echo 'Error: this script can only be executed by root'
    exit 1
fi

# creates SWAP on the server
echo Creating SWAP space
sudo fallocate -l 1024M /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo echo "/swapfile   none    swap    sw    0   0" >> /etc/fstab
sudo sysctl vm.swappiness=10
sudo echo "vm.swappiness=10" >> /etc/sysctl.conf
sudo sysctl vm.vfs_cache_pressure=50
sudo echo "vm.vfs_cache_pressure=50" >> /etc/sysctl.conf

# change time zone at your new server
echo Change server timezone
dpkg-reconfigure tzdata

# set the locale on your computer
echo Set server locale
export LC_ALL=en_US.UTF-8
export LANG="en_US.UTF-8"
export LANGUAGE=en_US.UTF-8
echo 'LC_ALL=en_US.UTF-8' >> /etc/environment
echo 'LANG=en_US.UTF-8' >> /etc/environment
echo 'LANGUAGE=en_US.UTF-8' >> /etc/environment
dpkg-reconfigure locales

# update server software
echo Updating software
apt-get -y update

# install a few useful tools
echo Installing some archive tools
apt-get -y install zip
apt-get -y install unzip
apt-get -y install p7zip-full

# install java
echo Installing Java
apt-get -y install default-jdk

# install nodejs and link to /nodejs and /node directories
echo Installing nodejs
apt-get -y install nodejs
ln -s /usr/bin/nodejs /usr/bin/node

# install npm and use npm to install pm2
echo Installing npm and pm2
apt-get -y install npm
npm install pm2@latest -g

# create pt directory structure
echo Creating base PT folder structure
cd /var/opt
mkdir pt
cd pt
mkdir releases

# create bot directory
echo Please enter a name for this bot. For best compatibility, use only lower case a-z and NO spaces. eg. myfirstbot
input -p 'Bot Name: ' botname
mkdir $botname
cd $botname

# download latest ProfitTrailer and extract to bot directory
echo Downloading latest ProfitTrailer release
wget https://github.com/$(wget https://github.com/taniman/profit-trailer/releases/latest -O - | egrep '/.*/.*/.*zip' -o)
unzip *zip
mv *zip ../releases
mv ProfitTrailer* ProfitTrailer
cd ProfitTrailer
mv * ..
cd ..
rm -rf ProfitTrailer
chmod +x ProfitTrailer.jar

clear
echo Installation complete. You must now reboot to finalise the installation. At the prompt below, simply type:
echo     reboot
echo
echo After rebooting, please proceed to edit your application.properties and settings files.
echo See https://wiki.profittrailer.com/doku.php?id=mandatory_settings for details.
echo
echo After you have completed the Mandatory Settings, launch ProfitTrailer. At the prompt, type:
echo     cd /var/opt/pt/$botname
echo     pm2 start pm2-ProfitTrailer.json
echo
echo You can then monitor the bot using the pm2 Dashboard by typing:
echo     pm2 dash
echo
echo Happy Profit Trailing!

# END
