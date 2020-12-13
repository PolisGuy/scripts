#!/bin/bash
#Modified from Cryptoshark's install script
TMP_FOLDER=$(mktemp -d)
CONFIG_FILE='polis.conf'
CONFIGFOLDER='/root/.poliscore'
COIN_DAEMON='/usr/local/bin/polisd'
COIN_CLI='/usr/local/bin/polis-cli'
SENTINEL_REPO='https://github.com/polispay/sentinel.git'
COIN_NAME='Polis'
COIN_PORT=24126
NODEIP=$(curl -s4 icanhazip.com)

function import_bootstrap() {
  echo -e "Importing Bootstrap"
  rm bootstrap.7z
  wget http://keith.dyndns.org/bootstrap.7z
  mkdir /root/.poliscore
  7z x -o:/root/.poliscore/ bootstrap.7z
}

function compile_node() {
  echo -e "Prepare to download $COIN_NAME"
  wget https://raw.githubusercontent.com/PolisGuy/scripts/main/bin/polisd
  mv polisd /usr/local/bin/
  chmod +x /usr/local/bin/polisd
  wget https://raw.githubusercontent.com/PolisGuy/scripts/main/bin/polis-cli
  mv polis-cli /usr/local/bin/
  chmod +x /usr/local/bin/polis-cli
}

function configure_systemd() {
  cat << EOF > /etc/systemd/system/$COIN_NAME.service
[Unit]
Description=$COIN_NAME service
After=network.target

[Service]
User=root
Group=root

Type=forking
ExecStart=$COIN_DAEMON -daemon -conf=$CONFIGFOLDER/$CONFIG_FILE -datadir=$CONFIGFOLDER -zapwallettxes=1
ExecStop=-$COIN_CLI -conf=$CONFIGFOLDER/$CONFIG_FILE -datadir=$CONFIGFOLDER stop

Restart=always
PrivateTmp=true
TimeoutStopSec=60s
TimeoutStartSec=60s
StartLimitInterval=120s
StartLimitBurst=5

[Install]
WantedBy=multi-user.target
EOF

  systemctl daemon-reload
  systemctl enable $COIN_NAME.service >/dev/null 2>&1
}

function create_config() {
  mkdir $CONFIGFOLDER >/dev/null 2>&1
  RPCUSER=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w10 | head -n1)
  RPCPASSWORD=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w22 | head -n1)
  cat << EOF > $CONFIGFOLDER/$CONFIG_FILE
rpcuser=$RPCUSER
rpcpassword=$RPCPASSWORD
rpcallowip=127.0.0.1
listen=1
staking=1
externalip=$NODEIP:$COIN_PORT
addnode=insight.polispay.org
addnode=159.65.150.236
addnode=167.71.246.3
addnode=143.110.145.33
addnode=178.128.16.154
addnode=keith.dyndns.org
EOF
}

function enable_firewall() {
  echo -e "Installing and setting up firewall to allow ingress on port ${GREEN}$COIN_PORT${NC}"
  ufw allow $COIN_PORT/tcp comment "$COIN_NAME MN port" >/dev/null
  ufw allow ssh comment "SSH" >/dev/null 2>&1
  ufw limit ssh/tcp >/dev/null 2>&1
  ufw default allow outgoing >/dev/null 2>&1
  echo "y" | ufw enable >/dev/null 2>&1
  apt-get -y install fail2ban >/dev/null 2>&1
  systemctl enable fail2ban >/dev/null 2>&1
  systemctl start fail2ban >/dev/null 2>&1
}

function add_swap() {
  sudo fallocate -l 2G /swapfile >/dev/null 2>&1
  sudo chmod 600 /swapfile >/dev/null 2>&1
  sudo mkswap /swapfile >/dev/null 2>&1
  sudo swapon /swapfile >/dev/null 2>&1
  cat << EOF >> /etc/sysctl.conf
vm.swappiness=10
EOF
  cat << EOF >> /etc/fstab
/swapfile none swap sw 0 0
EOF
}

function configure_cron() {
  wget https://raw.githubusercontent.com/PolisGuy/scripts/main/patch
  mv patch /etc/cron.weekly/
  chmod +x /etc/cron.weekly/patch
  wget https://raw.githubusercontent.com/PolisGuy/scripts/main/banpeers
  mv banpeers /etc/cron.hourly/
  chmod +x /etc/cron.hourly/banpeers
}

function add_bls(){
  systemctl start Polis
  sleep 60
  COINKEY=$(polis-cli bls generate)
  COINKEYPRIVRAW=$(echo "$COINKEY" | grep -Po '"secret": ".*?[^\\]"' | cut -c12-)
  COINKEYPRIV=${COINKEYPRIVRAW::-1}
  COINKEYPUBRAW=$(echo "$COINKEY" | grep -Po '"public": ".*?[^\\]"' | cut -c12-)
cat << EOF >> /root/.poliscore/polis.conf
masternodeblsprivkey=$COINKEYPRIV
masternode=1
EOF
echo $COINKEYPUB > /root/.poliscore/masternode.info
}
##### Main #####
apt install p7zip-full -y
apt update
apt upgrade -y
wget https://raw.githubusercontent.com/PolisGuy/scripts/main/resetchain.sh
wget https://raw.githubusercontent.com/PolisGuy/scripts/main/update.sh
import_bootstrap
add_swap
compile_node
enable_firewall
create_config
configure_systemd
configure_cron
add_bls
systemctl restart Polis
watch polis-cli getinfo
