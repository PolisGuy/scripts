Dear fellow Polis enthusiasts,
Here is where I keep scripts that I find usefull for managing my VPSs. All scripts assume you are logged in as root and that you are running Ubuntu 20 (although they should work on older versions too, but I just haven't bothered to test them)

install.sh 
This is for a fresh install of Polis. It pulls my custom compiled version of Polis with a higher connection limit.
To use this run:  
wget ...install.sh  
bash install.sh  


banpeers  
It bans all prior versions of the wallet hourly. This is usefull to prevent sync hangs caused by connecting to old peers that sometimes happen. This is automatically installed if you use my install.sh script above to install Polis.  
If you used Crytosharks script or other method to install then to use this run:  
wget https://raw.githubusercontent.com/PolisGuy/scripts/main/banpeers   
mv banpeers /etc/cron.hourly/  

resetchain.sh  
This deletes all the chain data from .poliscore then installs a fresh bootstrap which is WAY faster than syncing from scratch.
To use this run:  
rm resetchain.sh  
wget .../resetchain.sh   
bash resetchain.sh  


install_db.sh
This installs Berkely DB v 4.8. No need to do this manually if you use the compile_polis.sh script as it is included in that one.
wget https://raw.githubusercontent.com/PolisGuy/scripts/main/install_db4.sh 
bash install_db4.sh /root/

compile_polis.sh

wget https://raw.githubusercontent.com/PolisGuy/scripts/main/compile_polis.sh 
bash compile_polis.sh
