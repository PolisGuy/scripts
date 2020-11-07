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
wget https://s3.ca-central-1.amazonaws.com/s3.exoendo.ca/bootstrap.tar.gz
tar -zxvf bootstrap.tar.gz -C /root/.poliscore
systemctl start Polis
watch polis-cli getinfo
