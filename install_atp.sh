apt install libplist-utils gpg apt-transport-https -y
wget https://packages.microsoft.com/keys/microsoft.asc
apt-key add microsoft.asc
wget https://packages.microsoft.com/config/ubuntu/20.04/insiders-fast.list
mv insiders-fast.list /etc/apt/sources.list.d/microsoft-insiders-fast.list
apt update
apt install mdatp -y
