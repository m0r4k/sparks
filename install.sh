#!/bin/bash

echo -e "ADDING REPOSITORY \n"
apt-get install software-properties-common -y
add-apt-repository ppa:bitcoin/bitcoin
apt-get update
apt-get install libdb4.8++ libdb4.8 -y

echo -e "INSTALLING SPARKS DEPENDENCIES \n"
apt-get install boost libboost-system1.58.0 libboost-filesystem1.58.0 libboost-all \
                libboost-program-option libboost-program-options1.58.0 libboost-thread1.58.0 \
                libboost-chrono1.58.0 libboost-test1.58.0 libboost-*1.58.0 -y

apt-get install libminiupnpc10 libevent libevent-2.0-5 libevent-pthreads-2.0-5 -y

echo -e "INSTALLING SYSTOOLS \n"
apt-get install nano -y
apt-get install ufw -y
apt-get install htop -y
apt-get install fail2ban -y
apt-get install git python-virtualenv -y
apt-get install curl -y


echo -e "USER SETTINGS INSTALL \n"
read -p "Type your new Username: " username

adduser $username && adduser $username sudo

echo -n "Do you want to change  PermitRootLogin yes (y/n)? "
read answer
if echo "$answer" | grep -iq "^y" ;then
   sed -i -e 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
   cat /etc/ssh/sshd_config | grep PermitRootLogin

   printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
   echo -e "RESTARTING SSH pleas try to relogin with " $username "befor logging out \n"
   systemctl restart ssh
   printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -

else
    echo "No change in SSH"
fi

echo -n "Do you want to change  hostname yes (y/n)? "
read answer_hostname
if echo "$answer_hostname" | grep -iq "^y" ;then

   echo -e "please type in your new hostname.domainname \n"
   read hostname

   cp /etc/hostname /etc/hostname.old
   echo $hostname > /etc/hostname

   echo -e "when you are finished you need to reboot the system \n"
else
    echo "No change in hostname"
fi

echo -n "Do you want to activate the FIREWALL (y/n)? "
read anser_firewall
if echo "$answer:firewall" | grep -iq "^y" ;then
   ufw default allow outgoing
   ufw default deny incoming
   ufw allow ssh/tcp
   ufw limit ssh/tcp
   ufw allow 8890/tcp
   ufw logging on
   ufw enable
else
    echo "No change in ufw"
fi


echo -n "Do you want to activate Sparksd as a System Service ? (y/n) "
read answer_sparksd
if echo "$answer_sparksd" | grep -iq "^y" ;then
   cp ./systemd/sparksd.service /etc/systemd/system/sparksd_$username.service
   sed -i -e "s/CREATEDUSER/$username/g" /etc/systemd/system/sparksd_$username.service

   printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
   echo -e "\t when everything is configured start the service and enable it"
   echo -e "\t systemctl start sparksd_"$username".service"
   echo -e "\t systemctl enable sparksd_"$username".service"
   echo -e "\t try with some reboots if everything works fine!"
else
    echo "No change in ufw"
fi

printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
echo -e "CREATING CONFIG \n"
echo -e "generating Passord \n"

pwdgen=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 20 | head -n 1)
privkey=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 51 | head -n 1)
pubip=$(curl -s https://4.ifcfg.me/)

echo -e $pwdgen 
echo -e $privkey 

mkdir -p /home/$username/.Sparks
chown $username:$username /home/$username/.Sparks

cp  ./config/Sparks.conf /home/$username/.Sparks/Sparks.conf_gen
sed -i -e "s|USERNAME|$username|g"  /home/$username/.Sparks/Sparks.conf_gen
sed -i -e "s|PASSWORD|$pwdgen|g" /home/$username/.Sparks/Sparks.conf_gen
sed -i -e "s|PRIVKEY|$privkey|g" /home/$username/.Sparks/Sparks.conf_gen
sed -i -e "s|EXTIP|$pubip|g" /home/$username/.Sparks/Sparks.conf_gen

chown $username:$username /home/$username/.Sparks/Sparks.conf_gen

cp ./bin/Spark* /usr/local/bin

