#!/bin/bash

conf_flags="--without-gui --enable-cxx --disable-shared"
#cpu_amount=$(grep -c ^processor /proc/cpuinfo)
cpu_amount=5

echo -n "Do you want to compile Sparks from GIT Source ? (y/n) "
read answer_git
if echo "$answer_git" | grep -iq "^y" ;then
    echo -e "downloading ... \n"
    git clone https://github.com/sparkscrypto/Sparks.git
else
    echo "no"
fi

echo -n "Do you want to update dependensies ? (y/n) "
read answer_dep
if echo "$answer_dep" | grep -iq "^y" ;then
    echo -e "start install deps  ... \n"
    sudo apt-get update
    sudo apt-get upgrade
    sudo apt-get -y install build-essential
    sudo apt-get -y install libtool
    sudo apt-get -y install autotools-dev
    sudo apt-get -y install autoconf
    sudo apt-get -y install pkg-config
    sudo apt-get -y install libssl-dev
    sudo apt-get -y install software-properties-common
    sudo add-apt-repository -y ppa:bitcoin/bitcoin
    sudo apt-get update
    sudo apt-get -y install libdb4.8-dev libdb4.8++-dev
    sudo apt-get -y install libboost-all-dev
    sudo apt-get -y install libminiupnpc-dev
    sudo apt-get -y install ufw
    sudo apt-get -y install git automake libevent-dev
else
    echo "no install deps"
fi

echo -n "So we could start the compilation process ? (y/n) "
read answer_compile
if echo "$answer_compile" | grep -iq "^y" ;then
   cd Sparks
   ./autogen.sh
   ./configure $conf_flags
   
   START_TIME=`echo $(($(date +%s%N)/1000000000))`
   make -j $cpu_amount
   END_TIME=`echo $(($(date +%s%N)/1000000000))`
   COMPILE_TIME=$((($END_TIME - $START_TIME)/60))

  cd src
  strip Sparks-tx
  strip Sparks-cli
  strip Sparksd
  cp Sparksd Sparks-cli Sparks-tx ~/

else
    echo "no compilation"
fi

echo -n "SHOULD BE DONE NOW enjoy \n"

echo -n "COMPILATION TIME" $COMPILE_TIME "\n"

