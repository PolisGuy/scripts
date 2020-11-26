systemctl stop Polis
echo "Downloading Polis binaries"
rm polisd
rm polis-cli
wget https://github.com/PolisGuy/scripts/raw/main/bin/polisd
wget https://github.com/PolisGuy/scripts/raw/main/bin/polis-cli
mv polisd /usr/local/bin/
mv polis-cli /usr/local/bin/
chmod +x /usr/local/bin/polisd
chmod +x /usr/local/bin/polis-cli
systemctl start Polis
watch polis-cli getinfo
