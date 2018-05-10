# PTDroplet
Configure a fresh Digital Ocean droplet (Ubuntu 16.04) to run the latest ProfitTrailer release. Perfect for those with little or no Linux experience, or anyone who just wants to spin up a bot quickly.

This script will install:
 - archive management tools zip, unzip & 7z
 - Java
 - NodeJS
 - NPM
 - PM2
 - Latest ProfitTrailer release

Minimal requirements
 - At least 5 dollars a month Digital Ocean Ubuntu 16.04 64 bit server, 1 GB ram / 1 CPU, 25 GB SSD Disk, 1000 GB Transfer. Get it at https://m.do.co/c/9e2b87317b00. With this affiliate program link, they will instantly give you US$10 credit (which is 2 months free hosting) just for signing in with the link.
 - Optional, but recommended:
   - A domain name registered and pointing at your droplet IP address

After loging in to the droplet for the first time, copy the line bellow and execute it in the terminal

    curl -O https://raw.githubusercontent.com/mrhasbean/PTDroplet/master/ptdroplet.sh && bash ptdroplet.sh

During the installation you will be prompted for a name for your bot. Please use only upper / lower case alphanumeric characters with no spaces. Your bot will be installed in the following directory:

    /var/opt/pt/BOTNAME

Following installation, use your FTP client to connect to your VPS and edit the application.properties file

TO DO
 - Web Interface for initial configuration of application.properties
 - Integrate set up of LetsEncrypt SSL certificate
 - Integrate installation of PM2 Monitor (Web based monitor for PM2 - https://github.com/Tjatse/pm2-gui)

Raise an issue on Github for any problems you find.
