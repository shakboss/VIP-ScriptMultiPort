#!/bin/bash
#=== setup ===
cd 
rm -rf /root/udp
mkdir -p /root/udp
rm -rf /etc/udp-request
mkdir -p /etc/udp-request
sudo touch /etc/udp-request/udp-request
udp_dir='/etc/udp-request'
udp_file='/etc/udp-request/udp-request'

  rm -rf $udp_file &>/dev/null
  #rm -rf /etc/udp-request/udp-custom &>/dev/null
  rm -rf /usr/bin/udp-request &>/dev/null
  rm -rf /etc/limiter.sh &>/dev/null
  rm -rf /etc/udp-request/limiter.sh &>/dev/null
  rm -rf /etc/udp-request/module &>/dev/null
  rm -rf /usr/bin/udp &>/dev/null
  rm -rf /etc/udp-request/udpgw.service &>/dev/null
  rm -rf /etc/udpgw.service &>/dev/null
  systemctl stop udpgw &>/dev/null
  #systemctl stop udp-custom &>/dev/null
  systemctl stop udp-request &>/dev/null

 # [+get files ⇣⇣⇣+]
  source <(curl -sSL 'https://raw.githubusercontent.com/FasterExE/VIP-ScriptMultiPort/main/udp/module/module') &>/dev/null
  wget -O /etc/udp-request/module 'https://raw.githubusercontent.com/FasterExE/VIP-ScriptMultiPort/main/udp/module/module' &>/dev/null
  chmod +x /etc/udp-request/module

  #wget "https://raw.githubusercontent.com/FasterExE/VIP-ScriptMultiPort/main/udp/bin/udp-custom-linux-amd64" -O /root/udp/udp-custom &>/dev/null
  wget "https://raw.githubusercontent.com/FasterExE/VIP-ScriptMultiPort/main/udp/bin/udp-request-linux-amd64" -O /usr/bin/udp-request &>/dev/null
  #chmod +x /root/udp/udp-custom
  chmod +x /usr/bin/udp-request

  wget -O /etc/limiter.sh 'https://raw.githubusercontent.com/FasterExE/VIP-ScriptMultiPort/main/udp/module/limiter.sh'
  cp /etc/limiter.sh /etc/udp-request
  chmod +x /etc/limiter.sh
  chmod +x /etc/udp-request
  
  # [+udpgw+]
  wget -O /etc/udpgw 'https://raw.githubusercontent.com/FasterExE/VIP-ScriptMultiPort/main/udp/module/udpgw'
  mv /etc/udpgw /bin
  chmod +x /bin/udpgw

  # [+service+]
  wget -O /etc/udpgw.service 'https://raw.githubusercontent.com/FasterExE/VIP-ScriptMultiPort/main/udp/config/udpgw.service'
  wget -O /etc/udp-request.service 'https://raw.githubusercontent.com/FasterExE/VIP-ScriptMultiPort/main/udp/config/udp-request.service'
  
  mv /etc/udpgw.service /etc/systemd/system
  mv /etc/udp-request.service /etc/systemd/system

  chmod 640 /etc/systemd/system/udpgw.service
  chmod 640 /etc/systemd/system/udp-request.service
  
  systemctl daemon-reload &>/dev/null
  systemctl enable udpgw &>/dev/null
  systemctl start udpgw &>/dev/null
  systemctl enable udp-request &>/dev/null
  systemctl start udp-request &>/dev/null

  # [+config+]
  wget "https://raw.githubusercontent.com/FasterExE/VIP-ScriptMultiPort/main/udp/config/config.json" -O /root/udp/config.json &>/dev/null
  chmod +x /root/udp/config.json
  
  ufw disable &>/dev/null
  sudo apt-get remove --purge ufw firewalld -y
  apt remove netfilter-persistent -y

