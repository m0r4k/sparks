#!/bin/bash

echo -n -e "Password:"
read -s password

echo -n -e "\nSeconds:"
read -s seconds

Sparks-cli walletpassphrase $password $seconds

echo -e "\nWallet is unlocked"
