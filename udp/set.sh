#!/bin/bash
#=== setup ===
cd 
rm -rf /root/udp
mkdir -p /root/udp
rm -rf /etc/UDPRequest
mkdir -p /etc/UDPRequest
sudo touch /etc/UDPRequest/udp-request
udp_dir='/etc/UDPRequest'
udp_file='/etc/UDPRequest/udp-request'

sudo apt update -y
sudo apt upgrade -y
sudo apt install -y wget
sudo apt install -y curl
sudo apt install -y neofetch

source <(curl -sSL 'https://raw.githubusercontent.com/prjkt-nv404/UDP-Request-Manager/main/module/module')

time_reboot() {
  print_center -ama "${a92:-System/Server Reboot In} $1 ${a93:-Seconds}"
  REBOOT_TIMEOUT="$1"

  while [ $REBOOT_TIMEOUT -gt 0 ]; do
    print_center -ne "-$REBOOT_TIMEOUT-\r"
    sleep 1
    : $((REBOOT_TIMEOUT--))
  done
  rm /home/ubuntu/install.sh &>/dev/null
  rm /root/install.sh &>/dev/null
  echo -e "\033[01;31m\033[1;33m More Updates, Follow Us On \033[1;31m(\033[1;36mTelegram\033[1;31m): \033[1;37m@voltssh\033[0m"
  reboot
}

#======= CONFIGURATION OF UDP-CUSTOM & UDP-REQUEST ========

make_service() {
  ip_nat=$(ip -4 addr | grep inet | grep -vE '127(\.[0-9]{1,3}){3}' | cut -d '/' -f 1 | grep -oE '[0-9]{1,3}(\.[0-9]{1,3}){3}' | sed -n 1p)
  interface=$(ip -4 addr | grep inet | grep -vE '127(\.[0-9]{1,3}){3}' | grep "$ip_nat" | awk {'print $NF'})
  public_ip=$(grep -m 1 -oE '^[0-9]{1,3}(\.[0-9]{1,3}){3}$' <<<"$(wget -T 10 -t 1 -4qO- "http://ip1.dynupdate.no-ip.com/" || curl -m 10 -4Ls "http://ip1.dynupdate.no-ip.com/")")

cat <<EOF >/etc/systemd/system/udp-request.service
[Unit]
Description=UDP Request Service
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/root
ExecStart=/usr/bin/udp-request -ip=$public_ip -net=$interface -mode=system
Restart=always
RestartSec=3s

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload &>/dev/null
systemctl enable udp-request &>/dev/null
systemctl start udp-request &>/dev/null
}

# Check Ubuntu version
if [ "$(lsb_release -rs)" = "8*|9*|10*|11*|16.04*|18.04*" ]; then
  clear
  print_center -ama -e "\e[1m\e[31m=====================================================\e[0m"
  print_center -ama -e "\e[1m\e[33m${a94:-this script is not compatible with your operating system}\e[0m"
  print_center -ama -e "\e[1m\e[33m ${a95:-Use Ubuntu 20 or higher}\e[0m"
  print_center -ama -e "\e[1m\e[31m=====================================================\e[0m"
  rm /home/ubuntu/install.sh
  exit 1
else
  clear
  echo ""
  print_center -ama "A Compatible OS/Environment Found"
  print_center -ama " ⇢ Installation begins...! <"
  sleep 3

    # [change timezone to UTC +0]
  echo ""
  echo " ⇢ Change timezone to UTC +0"
  echo " ⇢ for Africa/Accra [GH] GMT +00:00"
  ln -fs /usr/share/zoneinfo/Africa/Accra /etc/localtime
  sleep 3

  # [+clean up+]
  rm -rf $udp_file &>/dev/null
  rm -rf /etc/UDPRequest/udp-request &>/dev/null
  rm -rf /etc/limiter.sh &>/dev/null
  rm -rf /etc/UDPRequest/limiter.sh &>/dev/null
  rm -rf /etc/UDPRequest/module &>/dev/null
  rm -rf /usr/bin/udp &>/dev/null
  rm -rf /etc/UDPRequest/udpgw.service &>/dev/null
  rm -rf /etc/udpgw.service &>/dev/null
  systemctl stop udpgw &>/dev/null
  systemctl stop udp-request &>/dev/null

# [+get files ⇣⇣⇣+]
  source <(curl -sSL 'https://raw.githubusercontent.com/prjkt-nv404/UDP-Custom-Installer-Manager/main/module/module') &>/dev/null
  wget -O /etc/UDPRequest/module 'https://raw.githubusercontent.com/prjkt-nv404/UDP-Custom-Installer-Manager/main/module/module' &>/dev/null
  chmod +x /etc/UDPRequest/module

# [+binary+]
  wget "https://raw.githubusercontent.com/prjkt-nv404/UDP-Request-Manager/main/bin/udp-request-linux-amd64" -O /root/udp/udp-request &>/dev/null
  mv /root/udp/udp-request /usr/bin
  chmod +x /usr/bin/udp-request

  wget -O /etc/limiter.sh 'https://raw.githubusercontent.com/prjkt-nv404/UDP-Request-Manager/main/module/limiter.sh'
  cp /etc/limiter.sh /etc/UDPRequest
  chmod +x /etc/limiter.sh
  chmod +x /etc/UDPRequest
  
  # [+udpgw+]
  wget -O /etc/udpgw 'https://raw.githubusercontent.com/prjkt-nv404/UDP-Request-Manager/main/module/udpgw'
  mv /etc/udpgw /bin
  chmod +x /bin/udpgw

  # [+service+]
  wget -O /etc/udpgw.service 'https://raw.githubusercontent.com/prjkt-nv404/UDP-Request-Manager/main/config/udpgw.service'
  # wget -O /etc/udp-request.service 'https://raw.githubusercontent.com/prjkt-nv404/UDP-Request-Manager/main/config/udp-request.service'
  
  mv /etc/udpgw.service /etc/systemd/system
  # mv /etc/udp-request.service /etc/systemd/system

  chmod 640 /etc/systemd/system/udpgw.service
  # chmod 640 /etc/systemd/system/udp-request.service
  
  systemctl daemon-reload &>/dev/null
  systemctl enable udpgw &>/dev/null
  systemctl start udpgw &>/dev/null
  make_service

  # [+config+]
  # wget "https://raw.githubusercontent.com/prjkt-nv404/UDP-Request-Manager/main/config/config.json" -O /root/udp/config.json &>/dev/null
  # chmod +x /root/udp/config.json

  # [+menu+]
  wget -O /usr/bin/udp 'https://raw.githubusercontent.com/prjkt-nv404/UDP-Request-Manager/main/module/udp' 
  chmod +x /usr/bin/udp
  ufw disable &>/dev/null
  sudo apt-get remove --purge ufw firewalld -y
  apt remove netfilter-persistent -y
  clear
  echo ""
  echo ""
  print_center -ama "${a103:-setting up, please wait...}"
  sleep 3
  title "${a102:-Installation Successful}"
  print_center -ama "${a103:-  To show menu type: \nudp\n}"
  msg -bar
  time_reboot 5
fi
