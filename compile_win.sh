#!/bin/bash

conf_flags="--with-gui=qt5 --enable-cxx --disable-shared"
#cpu_amount=($(grep -c ^processor /proc/cpuinfo)-1)
cpu_amount=4

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
    sudo apt-get -y install g++-mingw-w64-i686 mingw-w64-i686-dev g++-mingw-w64-x86-64 mingw-w64-x86-64-dev
    sudo apt-get -y install libqrencode-dev
    sudo apt-get -y install libqt5gui5 libqt5core5a libqt5dbus5 qttools5-dev qttools5-dev-tools libprotobuf-dev protobuf-compiler
else
    echo "no install deps"
fi


echo -n "Compile for 32bit or 64bit WINDOWS [32]? (32/64) "
read answer_arch
if echo "$answer_arch" | grep -iq "^3" ;then
   arch="w32"
else
   arch="w64"
fi

echo -n "So we could start the compilation process ? (y/n) "
read answer_compile
if echo "$answer_compile" | grep -iq "^y" ;then

   cd Sparks
   chmod a+x -R depends

   if echo "$arch" | grep  "32"; then
       host_prefix="i686-w64-mingw32"
       dep_prefix="`pwd`/depends/i686-w64-mingw32"
   else
       host_prefix="x86_64-w64-mingw32"
       dep_prefix="`pwd`/depends/x86_64-w64-mingw32"
   fi


echo "$arch" | grep -iq "^32" 
echo $arch
echo $host_prefix
echo $dep_prefix

   START_TIME=`echo $(($(date +%s%N)/1000000000))`  
   cd depends
   make HOST=$host_prefix -j $cpu_amount
   cd ..
   ./autogen.sh  --prefix=$arch_prefix
   ./configure  --prefix=$arch_prefix

   make -j $cpu_amount
   END_TIME=`echo $(($(date +%s%N)/1000000000))`
   COMPILE_TIME=$((($END_TIME - $START_TIME)/60))

  cd src
  #strip Sparks-tx
  #strip Sparks-cli
  #strip Sparksd
  #cp Sparksd Sparks-cli Sparks-tx ~/

else
    echo "no compilation"
fi

echo -e "SHOULD BE DONE NOW enjoy \n"

echo -e "COMPILATION TIME " $COMPILE_TIME "minutes \n"

