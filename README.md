Dear fellow Polis enthusiasts,
Here is where I keep scripts that I find usefull for managing my VPSs. All scripts assume you are logged in as root.

install.sh 
This is for a fresh install of Polis. It pulls my custom compiled versions of Polis.
To use this run:
wget ...install.sh | bash install.sh


banpeers
It bans all prior versions of the wallet hourly. This is usefull to prevent sync hangs caused by connecting to old peers that sometimes happen.
To use this run:
wget .../banpeers | mv banpeers /etc/cron.hourly/

resetchain.sh
This deletes all the chain data from .poliscore then installs a fresh bootstrap which is WAY faster than syncing from scratch.
To use this run:
wget .../resetchain.sh | bash resetchain.sh

