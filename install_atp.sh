apt install libplist-utils
apt install gpg
apt install apt-transport-https
wget https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
wget https://packages.microsoft.com/config/ubuntu/18.04/insiders-fast.list
mv insiders-fast.list /etc/apt/sources.list.d/microsoft-insiders-fast.list
apt update
apt install mdatp
