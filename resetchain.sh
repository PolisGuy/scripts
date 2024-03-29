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
sleep 15
echo
echo "Erasing chain data"
rm -R /root/.poliscore/blocks/
rm -R /root/.poliscore/chainstate/
rm -R /root/.poliscore/evodb/
rm -R /root/.poliscore/llmq/
rm /root/.poliscore/sporks.dat
rm /root/bootstrap*
#below are optional if you really want to clean things up
#rm /root/.poliscore/.lock
#rm /root/.poliscore/banlist.dat
#rm /root/.poliscore/db.log
#rm /root/.poliscore/debug.log
#rm /root/.poliscore/fee_estimates.dat
#rm /root/.poliscore/governance.dat
#rm /root/.poliscore/instantsend.dat
#rm /root/.poliscore/mempool.dat
#rm /root/.poliscore/mncache.dat
#rm /root/.poliscore/netfulfilled.dat
#rm /root/.poliscore/peers.dat
echo
echo "Downloading bootstrap"
wget http://159.203.48.172/bootstrap.7z
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

