#!/bin/sh
cd ~/Downloads	
wget https://www.jwz.org/xscreensaver/xscreensaver-6.17.tar.gz
tar zxvf xscreensaver-6.17.tar.gz
cd ./xscreensaver-6.17/
sudo apt install build-essential
sudo apt build-dep .
./configure --prefix=/usr
make tar
make deb
