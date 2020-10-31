systemctl stop Polis
cd /root/.poliscore
tar -cvzf /root/bootstrap.tar.gz blocks chainstate evodb llmq
cd ~
systemctl start Polis
