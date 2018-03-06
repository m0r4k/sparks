#!/bin/bash


if pgrep -x "Sparksd" > /dev/null
then
    daemon_name=$(ls /etc/systemd/system/ | grep sparks)
    if echo "$daemon_name" | grep -iq "^sparks" ;then
       sudo systemctl stop $daemon_name
   else
       Sparks-cli stop
   fi
fi


if ! pgrep -x "Sparksd" > /dev/null
then
    data=~/.Sparks
    rm -rf ${data}/{governance.dat,netfulfilled.dat,peers.dat,blocks,mncache.dat,chainstate,fee_estimates.dat,mnpayments.dat,banlist.dat}
    Sparksd -reindex
fi


echo -e "\nDeleted and started with reindex"
