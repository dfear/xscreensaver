#!/bin/sh
set -e

echo "APT::Get::Assume-Yes=yes" > /tmp/_tmp_apt.conf
export APT_CONFIG=/tmp/_tmp_apt.conf

cd ~/Downloads
wget https://www.jwz.org/xscreensaver/xscreensaver-6.17.tar.gz

if test -f ~/Downloads/xscreensaver-6.17.tar.gz; then
  echo "xscreensaver tarball exists. Extracting..."
  tar zxvf xscreensaver-6.17.tar.gz
  cd ./xscreensaver-6.17/
fi

sudo apt install build-essential

if test -d ~/Downloads/xscreensaver-6.17/; then
  echo "xscreensaver tarball extracted folder exists. Installing dependencies..."
  sudo apt build-dep .
fi

if test -f ~/Downloads/xscreensaver-6.17/configure.ac; then
  echo "configure file exists. run ./configure..."
  ./configure --prefix=/usr
fi

if test -f ~/Downloads/xscreensaver-6.17/Makefile.in; then
  echo "Makefile exists. Building binaries (tar/deb)..."
  make tar
  make deb
fi