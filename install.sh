#!/bin/bash
TMP_FOLDER=$(mktemp -d)
TMP_BS=$(mktemp -d)
CONFIG_FILE='polis.conf'
CONFIGFOLDER='/root/.poliscore'
COIN_DAEMON='/usr/local/bin/polisd'
COIN_CLI='/usr/local/bin/polis-cli'
COIN_REPO='https://github.com/polispay/polis/releases/download/v1.6.6/poliscore-1.6.6-x86_64-linux-gnu.tar.gz'
SENTINEL_REPO='https://github.com/polispay/sentinel.git'
COIN_NAME='Polis'
COIN_PORT=24126
COIN_BS='https://s3.ca-central-1.amazonaws.com/s3.exoendo.ca/bootstrap.tar.gz'
NODEIP=$(curl -s4 icanhazip.com)
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

function compile_node() {
  echo -e "Prepare to download $COIN_NAME"
  cd $TMP_FOLDER
  wget -q $COIN_REPO
  compile_error
  COIN_ZIP=$(echo $COIN_REPO | awk -F'/' '{print $NF}')
  tar xvf $COIN_ZIP --strip 1 >/dev/null 2>&1
  compile_error
  cp bin/polis{d,-cli} /usr/local/bin
  compile_error
  cd - >/dev/null 2>&1
  rm -rf $TMP_FOLDER >/dev/null 2>&1
  chmod +x /usr/local/bin/polisd
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
  sleep 3

  systemctl start $COIN_NAME.service
  systemctl enable $COIN_NAME.service >/dev/null 2>&1

  if [[ -z "$(ps axo cmd:100 | egrep $COIN_DAEMON)" ]]; then
    echo -e "${RED}$COIN_NAME is not running${NC}, please investigate. You should start by running the following commands as root:"
    echo -e "${GREEN}systemctl start $COIN_NAME.service"
    echo -e "systemctl status $COIN_NAME.service"
    echo -e "less /var/log/syslog${NC}"
    exit 1
  fi
}

function create_config() {
  mkdir $CONFIGFOLDER >/dev/null 2>&1
  RPCUSER=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w10 | head -n1)
  RPCPASSWORD=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w22 | head -n1)
  cat << EOF > $CONFIGFOLDER/$CONFIG_FILE
rpcuser=$RPCUSER
rpcpassword=$RPCPASSWORD
rpcallowip=127.0.0.1
staking=1
externalip=$NODEIP:$COIN_PORT
addnode=insight.polispay.org
addnode=116.203.116.205
addnode=95.216.56.42
addnode=207.180.218.18
addnode=80.211.45.85
addnode=176.233.138.86
addnode=5.189.161.94
addnode=149.28.209.101
addnode=167.99.85.39
addnode=157.230.87.57
addnode=keith.zapto.org
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

function compile_error() {
if [ "$?" -gt "0" ];
 then
  echo -e "${RED}Failed to compile $COIN_NAME. Please investigate.${NC}"
  exit 1
fi
}

function import_bootstrap() {
  wget $COIN_BS
  echo -e "Importing Bootstrap For $COIN_NAME"
  tar -zxvf bootstrap.tar.gz -C /root/.poliscore >/dev/null 2>&1
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
   cat << EOF >> /etc/cron.daily/patch
#!/bin/bash
apt update
apt upgrade -y
apt autoremove -y
reboot
EOF
chmod +x /etc/cron.daily/patch
#sed -i "s|25 6|0 $LOOP|g" /etc/crontab
}
##### Main #####
apt update
apt upgrade -y
add_swap
compile_node
import_bootstrap
enable_firewall
create_config
configure_systemd
configure_cron
timedatectl set-timezone America/Toronto
