#!/bin/bash
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
###########- COLOR CODE -##############
colornow=$(cat /etc/alexxa/theme/color.conf)
NC="\e[0m"
RED="\033[0;31m" 
COLOR1="$(cat /etc/alexxa/theme/$colornow | grep -w "TEXT" | cut -d: -f2|sed 's/ //g')"
COLBG1="$(cat /etc/alexxa/theme/$colornow | grep -w "BG" | cut -d: -f2|sed 's/ //g')"                    
###########- END COLOR CODE -##########

BURIQ () {
    curl -sS https://raw.githubusercontent.com/shakboss/VIP-ScriptMultiPort/main/access > /root/tmp
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
    rm -f /etc/.$user.ini > /dev/null 2>&1
    fi
    done
    rm -f /root/tmp
}

MYIP=$(curl -sS ipv4.icanhazip.com)
Name=$(curl -sS https://raw.githubusercontent.com/shakboss/VIP-ScriptMultiPort/main/access | grep $MYIP | awk '{print $2}')
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
    IZIN=$(curl -sS https://raw.githubusercontent.com/shakboss/VIP-ScriptMultiPort/main/access | awk '{print $4}' | grep $MYIP)
    if [ "$MYIP" = "$IZIN" ]; then
    Bloman
    else
    res="Permission Denied!"
    fi
    BURIQ
}
red='\e[1;31m'
green='\e[1;32m'
NC='\e[0m'
green() { echo -e "\\033[32;1m${*}\\033[0m"; }
red() { echo -e "\\033[31;1m${*}\\033[0m"; }
PERMISSION
if [ -f /home/needupdate ]; then
red "Your script need to update first !"
exit 0
elif [ "$res" = "Permission Accepted..." ]; then
echo -ne
else
red "Permission Denied!"
exit 0
fi
function cekvless(){
clear
echo -n > /tmp/other.txt
data=( `cat /etc/xray/config.json | grep '#&' | cut -d ' ' -f 2 | sort | uniq`);
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1 ${NC} ${COLBG1}             • RENEW VLESS USER •              ${NC} $COLOR1 $NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"

for akun in "${data[@]}"
do
if [[ -z "$akun" ]]; then
akun="tidakada"
fi

echo -n > /tmp/ipvless.txt
data2=( `cat /var/log/xray/access.log | tail -n 500 | cut -d " " -f 3 | sed 's/tcp://g' | cut -d ":" -f 1 | sort | uniq`);
for ip in "${data2[@]}"
do

jum=$(cat /var/log/xray/access.log | grep -w "$akun" | tail -n 500 | cut -d " " -f 3 | sed 's/tcp://g' | cut -d ":" -f 1 | grep -w "$ip" | sort | uniq)
if [[ "$jum" = "$ip" ]]; then
echo "$jum" >> /tmp/ipvless.txt
else
echo "$ip" >> /tmp/other.txt
fi
jum2=$(cat /tmp/ipvless.txt)
sed -i "/$jum2/d" /tmp/other.txt > /dev/null 2>&1
done

jum=$(cat /tmp/ipvless.txt)
if [[ -z "$jum" ]]; then
echo > /dev/null
else
jum2=$(cat /tmp/ipvless.txt | nl)
echo -e "$COLOR1 ${NC}   user : $akun";
echo -e "$COLOR1 ${NC}   $jum2";
fi
rm -rf /tmp/ipvless.txt
done

rm -rf /tmp/other.txt
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}" 
echo -e "$COLOR1┌────────────────────── BY ───────────────────────┐${NC}"
echo -e "$COLOR1 ${NC}         • Ilyass Najhi VPS-STORE•                 $COLOR1 $NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo ""
read -n 1 -s -r -p "   Press any key to back on menu"
menu-vless
}

function renewvless(){
clear
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1 ${NC} ${COLBG1}             • RENEW VLESS USER •              ${NC} $COLOR1 $NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
NUMBER_OF_CLIENTS=$(grep -c -E "^#& " "/etc/xray/config.json")
if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
echo -e "$COLOR1 ${NC}  • You have no existing clients!"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}" 
echo -e "$COLOR1┌────────────────────── BY ───────────────────────┐${NC}"
echo -e "$COLOR1 ${NC}         • Ilyass Najhi VPS-STORE •                 $COLOR1 $NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo ""
read -n 1 -s -r -p "   Press any key to back on menu"
menu-vless
fi
clear
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1 ${NC} ${COLBG1}             • RENEW VLESS USER •              ${NC} $COLOR1 $NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
grep -E "^#& " "/etc/xray/config.json" | cut -d ' ' -f 2-3 | column -t | sort | uniq | nl
echo -e "$COLOR1 ${NC}"
echo -e "$COLOR1 ${NC}  • [NOTE] Press any key to back on menu"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}" 
echo -e "$COLOR1┌────────────────────── BY ───────────────────────┐${NC}"
echo -e "$COLOR1 ${NC}         • Ilyass Najhi VPS-STORE •                 $COLOR1 $NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1───────────────────────────────────────────────────${NC}"
read -rp "   Input Username : " user
if [ -z $user ]; then
menu-vless
else
read -p "   Expired (days): " masaaktif
if [ -z $masaaktif ]; then
masaaktif="1"
fi
exp=$(grep -E "^#& $user" "/etc/xray/config.json" | cut -d ' ' -f 3 | sort | uniq)
now=$(date +%Y-%m-%d)
d1=$(date -d "$exp" +%s)
d2=$(date -d "$now" +%s)
exp2=$(( (d1 - d2) / 86400 ))
exp3=$(($exp2 + $masaaktif))
exp4=`date -d "$exp3 days" +"%Y-%m-%d"`
sed -i "/#& $user/c\#& $user $exp4" /etc/xray/config.json
systemctl restart xray > /dev/null 2>&1
clear
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1 ${NC} ${COLBG1}             • RENEW VLESS USER •              ${NC} $COLOR1 $NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1 ${NC}   [INFO]  $user Account Renewed Successfully"
echo -e "$COLOR1 ${NC}   "
echo -e "$COLOR1 ${NC}   Client Name : $user"
echo -e "$COLOR1 ${NC}   Days Added  : $masaaktif Days"
echo -e "$COLOR1 ${NC}   Expired On  : $exp4"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}" 
echo -e "$COLOR1┌────────────────────── BY ───────────────────────┐${NC}"
echo -e "$COLOR1 ${NC}         • Ilyass Najhi VPS-STORE •                 $COLOR1 $NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo ""
read -n 1 -s -r -p "   Press any key to back on menu"
menu-vless
fi
}

function delvless(){
    clear
NUMBER_OF_CLIENTS=$(grep -c -E "^#& " "/etc/xray/config.json")
if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1 ${NC} ${COLBG1}            • DELETE VLESS USER •              ${NC} $COLOR1 $NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1 ${NC}  • You Dont have any existing clients!"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}" 
echo -e "$COLOR1┌────────────────────── BY ───────────────────────┐${NC}"
echo -e "$COLOR1 ${NC}         • Ilyass Najhi VPS-STORE •                 $COLOR1 $NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo ""
read -n 1 -s -r -p "   Press any key to back on menu"
menu-vless
fi
clear
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1 ${NC} ${COLBG1}            • DELETE VLESS USER •              ${NC} $COLOR1 $NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
grep -E "^#& " "/etc/xray/config.json" | cut -d ' ' -f 2-3 | column -t | sort | uniq | nl
echo -e "$COLOR1 ${NC}"
echo -e "$COLOR1 ${NC}  • [NOTE] Press any key to back on menu"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1───────────────────────────────────────────────────${NC}"
read -rp "   Input Username : " user
if [ -z $user ]; then
menu-vless
else
exp=$(grep -wE "^#& $user" "/etc/xray/config.json" | cut -d ' ' -f 3 | sort | uniq)
sed -i "/^#& $user $exp/,/^},{/d" /etc/xray/config.json
systemctl restart xray > /dev/null 2>&1
clear
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1 ${NC} ${COLBG1}            • DELETE VLESS USE •              ${NC} $COLOR1 $NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1 ${NC}   • Accound Delete Successfully"
echo -e "$COLOR1 ${NC}"
echo -e "$COLOR1 ${NC}   • Client Name : $user"
echo -e "$COLOR1 ${NC}   • Expired On  : $exp"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}" 
echo -e "$COLOR1┌────────────────────── BY ───────────────────────┐${NC}"
echo -e "$COLOR1 ${NC}         • Ilyass Najhi VPS-STORE •                 $COLOR1 $NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo ""
read -n 1 -s -r -p "   Press any key to back on menu"
menu-vless
fi
}

function addvless(){
domain=$(cat /etc/xray/domain)
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1 ${NC} ${COLBG1}            • CREATE VLESS USER •              ${NC} $COLOR1 $NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
tls="$(cat ~/log-install.txt | grep -w "Vless TLS" | cut -d: -f2|sed 's/ //g')"
none="$(cat ~/log-install.txt | grep -w "Vless None TLS" | cut -d: -f2|sed 's/ //g')"
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
		read -rp "  Input Username : " -e user
        if [ -z $user ]; then
echo -e "$COLOR1 ${NC} [Error] Username cannot be empty "
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}" 
echo -e "$COLOR1┌────────────────────── BY ───────────────────────┐${NC}"
echo -e "$COLOR1 ${NC}         • Ilyass Najhi VPS-STORE •                 $COLOR1 $NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo ""
read -n 1 -s -r -p "   Press any key to back on menu"
menu
fi
		CLIENT_EXISTS=$(grep -w $user /etc/xray/config.json | wc -l)

if [[ ${CLIENT_EXISTS} == '1' ]]; then
echo -e "$COLOR1 ${NC} Please choose another name."
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}" 
echo -e "$COLOR1┌────────────────────── BY ───────────────────────┐${NC}"
echo -e "$COLOR1 ${NC}         • Ilyass Najhi VPS-STORE •                 $COLOR1 $NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo ""
read -n 1 -s -r -p "   Press any key to back on menu"
menu
fi
done

uuid=$(cat /proc/sys/kernel/random/uuid)
read -p "  Expired (days): " masaaktif
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
sed -i '/#vless$/a\#& '"$user $exp"'\
},{"id": "'""$uuid""'","email": "'""$user""'"' /etc/xray/config.json
sed -i '/#vlessgrpc$/a\#& '"$user $exp"'\
},{"id": "'""$uuid""'","email": "'""$user""'"' /etc/xray/config.json
vlesslink1="vless://${uuid}@${domain}:$tls?path=/vlessws&security=tls&encryption=none&type=ws#${user}"
vlesslink2="vless://${uuid}@${domain}:$none?path=/vlessws&encryption=none&type=ws#${user}"
vlesslink3="vless://${uuid}@${domain}:$tls?mode=gun&security=tls&encryption=none&type=grpc&serviceName=vless-grpc&sni=bug.com#${user}"

echo "$vlesslink1" > /root/akun/vless/vlesswstls-$user.txt
echo "$vlesslink2" > /root/akun/vless/vlesswsnontls-$user.txt
echo "$vlesslink3" > /root/akun/vless/vlessgrpc-$user.txt

systemctl restart xray
clear
echo -e "$COLOR1─────────────────────────────────────────────────${NC}" | tee -a /etc/log-create-user.log
echo -e "$COLOR1 ${NC} ${COLBG1}            • CREATE VLESS USER •              ${NC} $COLOR1 $NC" | tee -a /etc/log-create-user.log
echo -e "$COLOR1─────────────────────────────────────────────────${NC}" | tee -a /etc/log-create-user.log
echo -e "$COLOR1─────────────────────────────────────────────────${NC}" | tee -a /etc/log-create-user.log
echo -e "$COLOR1 ${NC} Remarks       : ${user}"  | tee -a /etc/log-create-user.log
echo -e "$COLOR1 ${NC} Expired On    : $exp"  | tee -a /etc/log-create-user.log
echo -e "$COLOR1 ${NC} Domain        : ${domain}"  | tee -a /etc/log-create-user.log
echo -e "$COLOR1 ${NC} port TLS      : $tls"  | tee -a /etc/log-create-user.log
echo -e "$COLOR1 ${NC} port none TLS : $none"  | tee -a /etc/log-create-user.log
echo -e "$COLOR1 ${NC} id            : ${uuid}" | tee -a /etc/log-create-user.log
echo -e "$COLOR1 ${NC} Encryption    : none"  | tee -a /etc/log-create-user.log
echo -e "$COLOR1 ${NC} Network       : ws"  | tee -a /etc/log-create-user.log
echo -e "$COLOR1 ${NC} Path          : /vless" | tee -a /etc/log-create-user.log
echo -e "$COLOR1 ${NC} Path          : vless-grpc"  | tee -a /etc/log-create-user.log
echo -e "$COLOR1─────────────────────────────────────────────────${NC}"  | tee -a /etc/log-create-user.log
echo -e "$COLOR1─────────────────────────────────────────────────${NC}" | tee -a /etc/log-create-user.log
echo -e "$COLOR1 ${NC} Link TLS :" | tee -a /etc/log-create-user.log
echo -e "$COLOR1 ${NC} ${vlesslink1}"  | tee -a /etc/log-create-user.log
echo -e "$COLOR1 ${NC}"   
echo -e "$COLOR1 ${NC} Link none TLS : " | tee -a /etc/log-create-user.log
echo -e "$COLOR1 ${NC} ${vlesslink2}"  | tee -a /etc/log-create-user.log
echo -e "$COLOR1 ${NC}" | tee -a /etc/log-create-user.log
echo -e "$COLOR1 ${NC} Link GRPC : " | tee -a /etc/log-create-user.log
echo -e "$COLOR1 ${NC} ${vlesslink3}"  | tee -a /etc/log-create-user.log
echo -e "$COLOR1─────────────────────────────────────────────────${NC}"  | tee -a /etc/log-create-user.log
echo -e "$COLOR1────────────────────── BY ───────────────────────${NC}" | tee -a /etc/log-create-user.log
echo -e "$COLOR1 ${NC}        • Ilyass Najhi VPN-STORE •                 $COLOR1 $NC" | tee -a /etc/log-create-user.log
echo -e "$COLOR1─────────────────────────────────────────────────${NC}" | tee -a /etc/log-create-user.log
echo ""  | tee -a /etc/log-create-user.log
read -n 1 -s -r -p "   Press any key to back on menu" | tee -a /etc/log-create-user.log
menu-vless
}


clear
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1 ${NC} ${COLBG1}             • VLESS PANEL MENU •              ${NC} $COLOR1 $NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e " $COLOR1┌───────────────────────────────────────────────┐${NC}"
echo -e " $COLOR1 $NC   ${COLOR1}[01]${NC} • ADD VLESS      ${COLOR1}[03]${NC} • DELETE VLESS${NC}   $COLOR1 $NC"
echo -e " $COLOR1 $NC   ${COLOR1}[02]${NC} • RENEW VLESS${NC}    ${COLOR1}[04]${NC} • USER ONLINE    $COLOR1 $NC"
echo -e " $COLOR1 $NC                                              ${NC} $COLOR1 $NC"
echo -e " $COLOR1 $NC   ${COLOR1}[00]${NC} • GO BACK${NC}                              $COLOR1 $NC"
echo -e " $COLOR1└───────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌────────────────────── BY ───────────────────────┐${NC}"
echo -e "$COLOR1 ${NC}         • Ilyass Najhi VPS-STORE •                 $COLOR1 $NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e ""
read -p " Select menu :  "  opt
echo -e ""
case $opt in
01 | 1) clear ; add-vless ;;
02 | 2) clear ; renewvless ;;
03 | 3) clear ; delvless ;;
04 | 4) clear ; cekvless ;;
00 | 0) clear ; menu ;;
*) clear ; menu-vless ;;
esac

       
