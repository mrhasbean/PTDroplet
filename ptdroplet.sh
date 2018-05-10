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

# Prevents doing this from other account than root
if [ "x$(id -u)" != 'x0' ]; then
    echo 'Error: this script can only be executed by root'
    exit 1
fi

echo Updating apt
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

echo Installation complete. Please proceed to edit your application.properties and settings files in the initialization folder as per the instructions on the ProfitTrailer Wiki (see https://wiki.profittrailer.com/doku.php?id=mandatory_settings)
echo
echo After you have completed the Mandatory Settings, launch ProfitTrailer by typing "pm2 start pm2-ProfitTrailer.json"
echo You can then monitor the bot using the pm2 Dashboard by typing "pm2 dash"
echo
echo Happy Profit Trailing!

# END
