#!/bin/bash
apt install p7zip-full -y
systemctl stop Polis
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
wget http://keith.dyndns.org/bootstrap.7z
7z x -o/root/.poliscore/ bootstrap.7z
systemctl start Polis
watch polis-cli getinfo
