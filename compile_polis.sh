cd ~
apt update
apt upgrade -y
apt install -y curl build-essential libtool autotools-dev automake pkg-config python3 libssl-dev libevent-dev bsdmainutils  unzip cmake
apt install -y libboost-all-dev
apt update
apt upgrade -y
rm v20181101.zip
rm -R bls-signatures-20181101
wget https://github.com/codablock/bls-signatures/archive/v20181101.zip
unzip v20181101.zip
cd bls-signatures-20181101
cmake .
make install -j8
read -r -s -p $'Press enter to continue...'

cd ~
#rm -R db-4.8.30
#wget http://download.oracle.com/berkeley-db/db-4.8.30.zip
#unzip db-4.8.30.zip
#cd db-4.8.30/build_unix/
#read -r -s -p $'Press enter to continue...'
#../dist/configure --prefix=/usr/local --enable-cxx
#read -r -s -p $'Press enter to continue...'
#make -j8
#make install -j8
#cd ~
rm -R polis
git clone https://github.com/polispay/polis.git
cd polis/depends/
make HOST=x86_64-linux-gnu -j8
cd ..
./autogen.sh
#export BDB_PREFIX='/root/db4'
./configure --without-gui --prefix=/root/polis/depends/x86_64-linux-gnu BDB_LIBS="-L/root/db4/lib -ldb_cxx-4.8" BDB_CFLAGS="-I/root/db4/include"
make -j8

#systemctl stop Polis
#mv src/polisd /usr/local/bin
#mv scr/polis-cli /usr/local/bin
