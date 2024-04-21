#!/bin/bash
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
#########################

BURIQ () {
    curl -sS https://raw.githubusercontent.com/FasterExE/VIP-ScriptMultiPort/main/access > /root/tmp
    data=( `cat /root/tmp | grep -E "^### " | awk '{print $2}'` )
    for user in "${data[@]}"
    do
    exp=( `grep -E "^### $user" "/root/tmp" | awk '{print $3}'` )
    d1=(`date -d "$exp" +%s`)
    d2=(`date -d "$biji" +%s`)
    exp2=$(( (d1 - d2) / 86400 ))
    if [[ "$exp2" -le "0" ]]; then
    echo $user > /etc/.$user.ini
    else
    rm -f  /etc/.$user.ini > /dev/null 2>&1
    fi
    done
    rm -f  /root/tmp
}
# https://raw.githubusercontent.com/FasterExE/VIP-ScriptMultiPort/main/access 
MYIP=$(curl -sS ipv4.icanhazip.com)
Name=$(curl -sS https://raw.githubusercontent.com/FasterExE/VIP-ScriptMultiPort/main/access | grep $MYIP | awk '{print $2}')
echo $Name > /usr/local/etc/.$Name.ini
CekOne=$(cat /usr/local/etc/.$Name.ini)

Bloman () {
if [ -f "/etc/.$Name.ini" ]; then
CekTwo=$(cat /etc/.$Name.ini)
    if [ "$CekOne" = "$CekTwo" ]; then
        res="Expired"
    fi
else
res="Permission Accepted..."
fi
}

PERMISSION () {
    MYIP=$(curl -sS ipv4.icanhazip.com)
    IZIN=$(curl -sS https://raw.githubusercontent.com/FasterExE/VIP-ScriptMultiPort/main/access | awk '{print $4}' | grep $MYIP)
    if [ "$MYIP" = "$IZIN" ]; then
    Bloman
    else
    res="Permission Denied!"
    fi
    BURIQ
}

clear
red='\e[1;31m'
green='\e[0;32m'
yell='\e[1;33m'
tyblue='\e[1;36m'
NC='\e[0m'
purple() { echo -e "\\033[35;1m${*}\\033[0m"; }
tyblue() { echo -e "\\033[36;1m${*}\\033[0m"; }
yellow() { echo -e "\\033[33;1m${*}\\033[0m"; }
green() { echo -e "\\033[32;1m${*}\\033[0m"; }
red() { echo -e "\\033[31;1m${*}\\033[0m"; }
cd /root
#System version number
if [ "${EUID}" -ne 0 ]; then
		echo "You need to run this script as root"
		exit 1
fi
if [ "$(systemd-detect-virt)" == "openvz" ]; then
		echo "OpenVZ is not supported"
		exit 1
fi

localip=$(hostname -I | cut -d\  -f1)
hst=( `hostname` )
dart=$(cat /etc/hosts | grep -w `hostname` | awk '{print $2}')
if [[ "$hst" != "$dart" ]]; then
echo "$localip $(hostname)" >> /etc/hosts
fi
mkdir -p /etc/xray

echo -e "[ ${tyblue}NOTES${NC} ] Before we go.. "
sleep 1
echo -e "[ ${tyblue}NOTES${NC} ] I need check your headers first.."
sleep 2
echo -e "[ ${green}INFO${NC} ] Checking headers"
sleep 1

secs_to_human() {
    echo "Installation time : $(( ${1} / 3600 )) hours $(( (${1} / 60) % 60 )) minute's $(( ${1} % 60 )) seconds"
}
start=$(date +%s)
ln -fs /usr/share/zoneinfo/GMT0 /etc/localtime
sysctl -w net.ipv6.conf.all.disable_ipv6=1 >/dev/null 2>&1
sysctl -w net.ipv6.conf.default.disable_ipv6=1 >/dev/null 2>&1

coreselect=''
cat> /root/.profile << END
# ~/.profile: executed by Bourne-compatible login shells.

if [ "$BASH" ]; then
  if [ -f ~/.bashrc ]; then
    . ~/.bashrc
  fi
fi

mesg n || true
clear
END
chmod 644 /root/.profile

echo -e "[ ${green}INFO${NC} ] Preparing the install file"
apt install git curl -y >/dev/null 2>&1
echo -e "[ ${green}INFO${NC} ] Alright good ... installation file is ready"
sleep 2

mkdir -p /etc/alexxa
mkdir -p /etc/alexxa/theme
mkdir -p /var/lib/alexxa-pro >/dev/null 2>&1
echo "IP=" >> /var/lib/alexxa-pro/ipvps.conf

if [ -f "/etc/FasterExE/hello" ]; then
echo ""
echo -e "[ ${green}INFO${NC} ] Script Already Installed"
echo -ne "[ ${yell}WARNING${NC} ] Do you want to install again ? (y/n)? "
read answer
if [ "$answer" == "${answer#[Yy]}" ] ;then
rm setup.sh
sleep 10
exit 0
else
clear
fi
fi

echo ""
wget -q https://raw.githubusercontent.com/FasterExE/VIP-ScriptMultiPort/main/dependencies.sh;chmod +x dependencies.sh;./dependencies.sh
rm dependencies.sh
clear
apt install lolcat -y
clear
echo -e "${red}    ♦️${NC} ${green} CUSTOM SETUP DOMAIN VPS     ${NC}"
echo -e "${red}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m${NC}"
echo "1. Use Script Domain"
echo "2. Choose Your Own Domain"
echo -e "${red}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m${NC}"
read -rp "Choose Your Domain Installation : " dom 

if test $dom -eq 1; then
clear

echo -e "$green[INFO]$NC Install SlowDNS!"
sleep 2
clear
rm -rf slhostdns.sh

wget https://raw.githubusercontent.com/FasterExE/VIP-ScriptMultiPort/main/ssh/slhostdns.sh && chmod +x slhostdns.sh && ./slhostdns.sh

wget https://raw.githubusercontent.com/FasterExE/VIP-ScriptMultiPort/main/ssh/install-sldns && chmod +x install-sldns && ./install-sldns
elif test $dom -eq 2; then
yellow "Add Domain for vmess/vless/trojan dll"
echo " "
read -rp "Input ur domain : " -e pp
read -rp "Input ur NS DOMAIN : " -e nsdomain
echo "$pp" > /root/subdomain
echo "$nsdomain"> /root/nsdomain
echo "$pp" > /root/domain
echo "$pp" > /root/scdomain
echo "$pp" > /etc/xray/domain
echo "$pp" > /etc/xray/scdomain
echo "IP=$pp" > /var/lib/alexxa-pro/ipvps.conf
clear
wget https://raw.githubusercontent.com/FasterExE/VIP-ScriptMultiPort/main/ssh/install-sldns && chmod +x install-sldns && ./install-sldns
else 
echo "Not Found Argument"
exit 1
fi
echo -e "${GREEN}Done!${NC}"
sleep 2
clear

#yellow "Add Domain for vmess/vless/trojan dll"
#echo " "
#read -rp "Input ur domain : " -e pp
#echo "$pp" > /root/domain
#echo "$pp" > /root/scdomain
#echo "$pp" > /etc/xray/domain
#echo "$pp" > /etc/xray/scdomain
#echo "IP=$pp" > /var/lib/alexxa-pro/ipvps.conf

#THEME RED
cat <<EOF>> /etc/alexxa/theme/red
BG : \E[40;1;41m
TEXT : \033[0;31m
EOF
#THEME BLUE
cat <<EOF>> /etc/alexxa/theme/blue
BG : \E[40;1;44m
TEXT : \033[0;34m
EOF
#THEME GREEN
cat <<EOF>> /etc/alexxa/theme/green
BG : \E[40;1;42m
TEXT : \033[0;32m
EOF
#THEME YELLOW
cat <<EOF>> /etc/alexxa/theme/yellow
BG : \E[40;1;43m
TEXT : \033[0;33m
EOF
#THEME MAGENTA
cat <<EOF>> /etc/alexxa/theme/magenta
BG : \E[40;1;43m
TEXT : \033[0;33m
EOF
#THEME CYAN
cat <<EOF>> /etc/alexxa/theme/cyan
BG : \E[40;1;46m
TEXT : \033[0;36m
EOF
#THEME CONFIG
cat <<EOF>> /etc/alexxa/theme/color.conf
blue
EOF
    
#install ssh ovpn
echo -e "$green[INFO]$NC Install SSH & OpenVPN!"
sleep 2
clear
wget https://raw.githubusercontent.com/FasterExE/VIP-ScriptMultiPort/main/ssh/ssh-vpn.sh && chmod +x ssh-vpn.sh && ./ssh-vpn.sh
sudo apt-get -y remove apache2
sudo apt-get -y purge apache2
#Instal Xray
echo -e "$green[INFO]$NC Install Install XRAY!"
sleep 2
clear
wget https://raw.githubusercontent.com/FasterExE/VIP-ScriptMultiPort/main/xray/ins-xray.sh && chmod +x ins-xray.sh && ./ins-xray.sh
clear
wget https://raw.githubusercontent.com/FasterExE/VIP-ScriptMultiPort/main/backup/set-br.sh && chmod +x set-br.sh && ./set-br.sh
clear
wget https://raw.githubusercontent.com/FasterExE/VIP-ScriptMultiPort/main/websocket/insshws.sh && chmod +x insshws.sh && ./insshws.sh
clear
echo -e "$green[INFO]$NC Download Extra Menu"
sleep 2
wget https://raw.githubusercontent.com/FasterExE/VIP-ScriptMultiPort/main/update/update.sh && chmod +x update.sh && ./update.sh
clear
cat> /root/.profile << END
# ~/.profile: executed by Bourne-compatible login shells.

if [ "$BASH" ]; then
  if [ -f ~/.bashrc ]; then
    . ~/.bashrc
  fi
fi

mesg n || true
clear
menu
END
chmod 644 /root/.profile

if [ -f "/root/log-install.txt" ]; then
rm /root/log-install.txt > /dev/null 2>&1
fi
if [ -f "/etc/afak.conf" ]; then
rm /etc/afak.conf > /dev/null 2>&1
fi
if [ ! -f "/etc/log-create-user.log" ]; then
echo "Log All Account " > /etc/log-create-user.log
fi
history -c
serverV=$( curl -sS https://raw.githubusercontent.com/FasterExE/VIP-ScriptMultiPort/main/version  )
echo $serverV > /opt/.ver
aureb=$(cat /home/re_otm)
b=11
if [ $aureb -gt $b ]
then
gg="PM"
else
gg="AM"
fi
curl -sS ifconfig.me > /etc/myipvps
rm /etc/stunnel/stunnel.pem
cat > /etc/stunnel/stunnel.pem <<-END
-----BEGIN CERTIFICATE-----
MIIEFzCCAv+gAwIBAgIUFHVEAYpDNIbzC7HvwP9D8AjRz+gwDQYJKoZIhvcNAQEL
BQAwgZoxCzAJBgNVBAYTAk1BMREwDwYDVQQIDAhCYXJub3VzaTETMBEGA1UEBwwK
Q2FzYWJsYW5jYTESMBAGA1UECgwJRmFzdGVyQ0ZHMRIwEAYDVQQLDAlGYXN0ZXJF
eEUxEzARBgNVBAMMCmlseWFzcy54eXoxJjAkBgkqhkiG9w0BCQEWF2lseWFzc25h
amhpMTBAZ21haWwuY29tMB4XDTI0MDQxOTEyMTUzN1oXDTI3MDExNDEyMTUzN1ow
gZoxCzAJBgNVBAYTAk1BMREwDwYDVQQIDAhCYXJub3VzaTETMBEGA1UEBwwKQ2Fz
YWJsYW5jYTESMBAGA1UECgwJRmFzdGVyQ0ZHMRIwEAYDVQQLDAlGYXN0ZXJFeEUx
EzARBgNVBAMMCmlseWFzcy54eXoxJjAkBgkqhkiG9w0BCQEWF2lseWFzc25hamhp
MTBAZ21haWwuY29tMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAp03l
w+3x6mhMGH/F5Q04b8K77sjFAjPJH8w5pXJ7MrrSRm8YBq+QJRMsWbRkApuRBXMb
J5EXMRmiHUkSYdyzXY++c/kOAodnkVeGZqwHCWoefYxKmyUZ4Jb367Z6MHBO9+IQ
zJnUvGcoH2DeCptqSNHXdNV2F9asNPqswcjdMCFE4DrjfTH7FLt6EbP6OjWPcipt
xzfti6BIZkAnBMpzBbzyx4ooQvT3s4bsoZxkcCRh5QKsp1r+q7NJa2FGZqCmHIhL
gBTu0/JYAYeOwoKfSLpKT7e5aFW96iq/yRFzI8lShOBi8zzPO4nzO9iTjh5m8AAS
SWBcDGpkwhBUfAYQPQIDAQABo1MwUTAdBgNVHQ4EFgQUY4WM+jgXBivYVUdkzngc
kXR9hKowHwYDVR0jBBgwFoAUY4WM+jgXBivYVUdkzngckXR9hKowDwYDVR0TAQH/
BAUwAwEB/zANBgkqhkiG9w0BAQsFAAOCAQEAPEqVxLCLsnPU8SJ/rGNKp1Y1hnxT
PxdLU/pR+a55iOyo1LP5v7OrgTZIIAtjE76rC+UttwS2FSLhaJrhNaix92KF8S9g
Wl4PJrEhs7ClFzynbwQwyzStMyVK5apiY9GJnk1uiCF51BPaoxyNy3wpQL/DpH6Y
+zPVQeXuos4A9TRcdZIvYjN41nRyCyYpwhfje8Iqk6A+oAwia1gSWSC2PkGOw02A
UKs8pRaeTrX7R3ELY1GWZ4C4G9XZsDR8gd42ACamvbQpnU0MOBAkODKIO8fB31uK
lBUIlo8BdIL9g9ny6Ip5qWtdj3dm02CW47Cv60vkkx6dHJm4ur0/UVCqmA==
-----END CERTIFICATE-----
-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEAp03lw+3x6mhMGH/F5Q04b8K77sjFAjPJH8w5pXJ7MrrSRm8Y
Bq+QJRMsWbRkApuRBXMbJ5EXMRmiHUkSYdyzXY++c/kOAodnkVeGZqwHCWoefYxK
myUZ4Jb367Z6MHBO9+IQzJnUvGcoH2DeCptqSNHXdNV2F9asNPqswcjdMCFE4Drj
fTH7FLt6EbP6OjWPciptxzfti6BIZkAnBMpzBbzyx4ooQvT3s4bsoZxkcCRh5QKs
p1r+q7NJa2FGZqCmHIhLgBTu0/JYAYeOwoKfSLpKT7e5aFW96iq/yRFzI8lShOBi
8zzPO4nzO9iTjh5m8AASSWBcDGpkwhBUfAYQPQIDAQABAoIBABHF0qy3sEVIgxzv
JeSpPN+Sfkhlh5guTCVWmqEawj+nXQMidhjvuY5WtRVqdl1YjVVY3v+bCC2tHW2i
/5Lp0RwVUxQa1wQpwjTMaXiquaykW0zXBG3qyQ70uq2NmvleVOU8XLB/fvvssXRz
4+KYk/fcYtkEfCEYKv8NyiBj6CtekWtEwWa5KC0Q81mmECN2OEcOgUpWnNow8nfk
D0NV2I+bZggkXNS170WT5YPixi5YnB2lj4p+GVf4JQZ6/c/CSsplhCDs458MdWL3
xgq2DSvF0oumPXFzaTUpgPAQzK8mN9LxmYMPcG+6/LSEDCENx6gU5HXdrcH3SUVK
zzun1gECgYEA0Zw5s2UVlloubePEWWoENnqWcBj1A3AIkaUrRGsKXKunhnMwC75z
W8x6mCN9sFM/A0+BF0SJI5U9ZiraA9uy2Ff1Jz7XsERVdabhNlF/zEaRcOG7JhTE
uROneqdFy2DsImAZurs2JFUmHId3r3fVXbYsUx0AXbFa3anWebCKtf0CgYEAzFTE
DL1W5mANgqI6R/3sOkDMFz4KK3UG9XRuar/N6sL0yKRHGg0ejGcwZiaYHnyxNg2J
7HU38DEZ/z+lLkqAktXYi8kuXmgw+2EnAcqCIUOAf/LGVbWj5R7HSvUqRsLUsecY
a00+ps/oRZ/VIyVKjeahf2JsXMv7oDmJoOZut0ECgYEAw+o4SEPX7IL32IBF+qjL
rTvhNn8tKvxhFfiCO12s/rb2SwWIx8FHw2qYv3CUvuTgBbEe4GePorGQBNlSkr6b
J/j2S6tCIB+OnPvQjluYjo76y75AlTReNvp21H5aDuDVdL/L7KukzErF52564Iep
5wAp57k4qVnmqz5eF7l5vOUCgYEAhPL6hReFPWxuHfuUVFdhpx2WLeFOGKySlI7n
cUnPn9quDwbkxIyYvd4+XZjrDZswau0wOsyiUwR/19b/kTkko2XE+l8ybnb4t/ek
u8OaHC6ho57Bce837tKx9ZHDqjsGzaKB/v9JrpxEk1jGA5I2ClJv7kSKIW8QEFaf
uDN3AoECgYB/wU9F18qj6UYYeDLHdfQCNWPAWCpejeVdGjL/pSzJ1DQUphcsHmCZ
8ezJIzdJcY+3UAid+uIQmx46ltAnmdFUn8+t+EvL7XwgVjQHhUQpbVXpyl6N50A0
WLAE2BHVlrJe9eaDy0HwAMykjGCeUod2qcZjNGcHUmQ7RIwXua9SGw==
-----END RSA PRIVATE KEY-----
END
systemctl daemon-reload
systemctl restart stunnel4
clear
echo " "
echo "====================-[ Ilyass Najhi VPN-STORE ]-===================="
echo ""
echo "------------------------------------------------------------"
echo ""  | tee -a log-install.txt
echo "   >>> Service & Port"  | tee -a log-install.txt
echo "   - OpenSSH                 : 22"  | tee -a log-install.txt
echo "   - SSH Websocket           : 80 [ON]" | tee -a log-install.txt
echo "   - SSH SSL Websocket       : 443" | tee -a log-install.txt
echo "   - Stunnel4                : 447, 777" | tee -a log-install.txt
echo "   - Dropbear                : 109, 143" | tee -a log-install.txt
echo "   - Badvpn                  : 7100-7900" | tee -a log-install.txt
echo "   - Nginx                   : 81" | tee -a log-install.txt
echo "   - XRAY  Vmess TLS         : 443" | tee -a log-install.txt
echo "   - XRAY  Vmess None TLS    : 80" | tee -a log-install.txt
echo "   - XRAY  Vless TLS         : 443" | tee -a log-install.txt
echo "   - XRAY  Vless None TLS    : 80" | tee -a log-install.txt
echo "   - Trojan GRPC             : 443" | tee -a log-install.txt
echo "   - Trojan WS               : 443" | tee -a log-install.txt
echo "   - Sodosok WS/GRPC         : 443" | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "   >>> Server Information & Other Features"  | tee -a log-install.txt
echo "   - Timezone                : Asia/Karachi (GMT +5)"  | tee -a log-install.txt
echo "   - Fail2Ban                : [ON]"  | tee -a log-install.txt
echo "   - Dflate                  : [ON]"  | tee -a log-install.txt
echo "   - IPtables                : [ON]"  | tee -a log-install.txt
echo "   - Auto-Reboot             : [ON]"  | tee -a log-install.txt
echo "   - IPv6                    : [OFF]"  | tee -a log-install.txt
echo "   - Autoreboot On           : $aureb:00 $gg GMT +0" | tee -a log-install.txt
echo "   - Autobackup Data" | tee -a log-install.txt
echo "   - AutoKill Multi Login User" | tee -a log-install.txt
echo "   - Auto Delete Expired Account" | tee -a log-install.txt
echo "   - Fully automatic script" | tee -a log-install.txt
echo "   - VPS settings" | tee -a log-install.txt
echo "   - Admin Control" | tee -a log-install.txt
echo "   - Backup & Restore Data" | tee -a log-install.txt
echo "   - Full Orders For Various Services" | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "   >>> About " | tee -a log-install.txt
echo "   - Script Presented By      : Ghafoor Ali" | tee -a log-install.txt
echo "   - Contact (Only Text)      : t.me/ghafoorali" | tee -a log-install.txt
echo "------------------------------------------------------------"
echo "auto reboot after 10 seconds"
echo "=============-[ Ilyass Najhi VPN-STORE ]-==============="
echo -e ""
echo ""
sleep 8
echo "" | tee -a log-install.txt
rm /root/cf.sh >/dev/null 2>&1
rm /root/setup.sh >/dev/null 2>&1
rm /root/insshws.sh 
rm /root/update.sh
secs_to_human "$(($(date +%s) - ${start}))" | tee -a log-install.txt
echo -e ""
clear
mkdir /etc/FasterExE
touch /etc/FasterExE/hello
echo 'script by ilyass najhi t.me/IlyassExE .. enjoy !' > /etc/FasterExE/hello
reboot
fi
