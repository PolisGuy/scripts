  echo -e "Prepare to download $COIN_NAME"
  wget https://raw.githubusercontent.com/PolisGuy/scripts/main/polisd
  mv polisd /usr/local/bin/
  chmod +x /usr/local/bin/polisd
  wget https://raw.githubusercontent.com/PolisGuy/scripts/main/polis-cli
  mv polis-cli /usr/local/bin/
  chmod +x /usr/local/bin/polis-cli
