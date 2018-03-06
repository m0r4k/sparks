# Sparks Masternode AUTOMATIC Installer

Befor we start some interesting Information for you! Theses scripts are made for UBUNTU 16.04 
So any other Distro needs to be adapted -> but the work is not done now!

The script is configuring SPK Masternode SERVER 
- sshd with PermitRootLogin no
- ufw setup
- fail2ban (ssh enabled)
- User Installation
- systemd script installation
- and Std. Spark config
 
# Work to be done!

  - splitting scripts
  - Masternode self setup script
  - masternodeprivkey generation out of bash script
  - ...
 
# Howto compile (WIN 32/64)

Follow the instructions of compile_win.sh

```sh
root@server:~/# git clone https://github.com/m0r4k/sparks
root@server:~/# cd sparks
root@server:~/sparks/# chmod u+x compile_win.sh && ./compile_win.sh
```

ATTENTION: Binaries are in 

```sh
root@server:~/# cd sparks/Sparks/src              #here are the cmd binaries (exe)
root@server:~/# cd sparks/Sparks/src/qt		  #here is the qt binary (exe)
```


# Howto compile (LINUX/UNIX)

```sh
root@server:~/# git clone https://github.com/m0r4k/sparks
root@server:~/# cd sparks
root@server:~/sparks/# chmod u+x compile.sh && ./compile_win.sh
```

ATTENTION: Binaries (without gui) are copied to ~/ (HOMEFOLDER)


# Howto install
Login to your HOST (Virtual or REAL) with root account. Go where ever you
want to download the git repository.

```sh
root@server:~/# git clone https://github.com/m0r4k/sparks
root@server:~/# cd sparks
root@server:~/sparks/# chmod u+x install.sh
root@server:~/sparks/# ./install.sh
```

if everything went well you should see something  in 
```sh
root@server:~/# cat /home/created_user/.Sparks/Sparks.conf_gen
root@server:~/# cat /etc/systemd/system/sparksd_created_user.service
```
### first time starting
```sh
user@server:~/# Spraksd -daemon
user@server:~/# privkey=$(Sparks-cli masternode genkey)
user@server:~/# Sparks-cli stop
user@server:~/# sed -i -e "s|PRIVKEY|$privkey|g" .Sparks/Sparks.conf_gen
user@server:~/# cp ./Sparks.conf_gen ./Sparks.conf
user@server:~/# Sparksd
```
THAS it -> your server is RUNNING

### next STEP
Send 1000 SPKs to your wallet which should run now since last command. And if
you are patient I will explain in futre how to ENABLE MASTERNODE -> or even
will wirte some scripts.

If you want to know now READ the END of DOCs of 
https://github.com/sparkscrypto/Sparks/blob/master/Masternode%20Guide%20Public.pdf


# What is helping me going on ?
This is now a one man show -> and since spark coins are not realy expensive you
are welcome to send me some COINS.

| COIN | WALLET - ADDRESS |
| ------ | ------ |
| SPK | GgPS4oL4oDLeGyEtrTyscTkLQm25zb9RBZ |

# License
Sparks Core is released under the terms of the MIT license. See COPYING for more information or see
https://opensource.org/licenses/MIT.

So because I do and will use opensource Software this project is free to share


# The Hard way
I compiled Spark with GCC7 so If you are interested in doing the installation the hard way, use the
docs on https://github.com/sparkscrypto/Sparks. If you need to setup a bunch of masternodes, this could
be quite timeintensive.

# WHO AM I?
I'm not a DEV of sparks so don't ask me if I would like to takeover, fork, copy sparks with you and your team.
I love to do what I do and whait for inspiration.
