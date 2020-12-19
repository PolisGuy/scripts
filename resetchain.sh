#!/bin/bash
echo
echo "Installing 7zip"
apt install p7zip-full -y
#the bootstrap get remade at the top of every hour and takes 5 minutes so wait until is is 5 past the hour to start
Minute=`date +%M`
while [ $Minute -lt 5 ]
do
  echo "It is $Minute after the hour. Waiting until 5 minutes after the hour."
  sleep 10
  Minute=`date +%M`
done
echo
echo "Stopping Polis"
systemctl stop Polis
echo
echo "Erasing chain data"
rm /root/.poliscore/.lock
rm /root/.poliscore/banlist.dat
rm -R /root/.poliscore/blocks/
rm -R /root/.poliscore/chainstate/
rm /root/.poliscore/db.log
rm /root/.poliscore/debug.log
rm -R /root/.poliscore/evodb/
rm /root/.poliscore/fee_estimates.dat
rm /root/.poliscore/governance.dat
rm /root/.poliscore/instantsend.dat
rm -R /root/.poliscore/llmq/
rm /root/.poliscore/mempool.dat
rm /root/.poliscore/mncache.dat
rm /root/.poliscore/netfulfilled.dat
rm /root/.poliscore/peers.dat
rm /root/.poliscore/sporks.dat
rm /root/bootstrap*
echo
echo "Downloading bootstrap"
wget https://polisguy.s3.ca-central-1.amazonaws.com/bootstrap.7z
echo
echo "Extracting bootstrap"
7z x -o/root/.poliscore/ bootstrap.7z
echo
echo "Adding banscore=1 to polis.conf if it isn't there already"
if grep -q banscore /root/.poliscore/polis.conf
then
  echo "banscore=1 is alredy in polis.conf"
else
  echo "banscore=1" >> /root/.poliscore/polis.conf
fi
echo
echo "Starting Polis"
systemctl start Polis
watch polis-cli getinfo

