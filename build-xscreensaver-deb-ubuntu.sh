#!/bin/sh
set -e

LATEST_DOWNLOAD_FILENAME=`curl -s -A "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36" https://www.jwz.org/xscreensaver/download.html | grep "xscreensaver-" | grep "tar.gz" | cut -d '"' -f 4 | head -n 1`
LATEST_DOWNLOAD_URL_BASEPATH="https://www.jwz.org/xscreensaver/"
LATEST_DOWNLOAD_URL=$LATEST_DOWNLOAD_URL_BASEPATH$LATEST_DOWNLOAD_FILENAME
DOWNLOAD_FOLDER="$HOME/Downloads"
#DOWNLOAD_FOLDER="."
DOWNLOADED_FILEPATH="${DOWNLOAD_FOLDER}/${LATEST_DOWNLOAD_FILENAME}"
EXTRACTED_FOLDER_NAME=`basename -s .tar.gz ${LATEST_DOWNLOAD_FILENAME}`
EXTRACTED_FOLDERPATH="${DOWNLOAD_FOLDER}/${EXTRACTED_FOLDER_NAME}/"

cd $DOWNLOAD_FOLDER
echo $LATEST_DOWNLOAD_URL
wget $LATEST_DOWNLOAD_URL

echo $EXTRACTED_FOLDER_NAME
echo $EXTRACTED_FOLDERPATH
#exit

if test -f "${DOWNLOADED_FILEPATH}"; then
  echo "xscreensaver tarball exists. Extracting..."
  tar zxf "${DOWNLOADED_FILEPATH}"
fi

#exit

sudo apt update
sudo apt upgrade
sudo apt-get install -y build-essential

if test -d "${EXTRACTED_FOLDERPATH}"; then
  cd "${EXTRACTED_FOLDERPATH}"
  echo "xscreensaver tarball extracted folder exists. Installing dependencies..."
  sudo apt-get build-dep -y .
fi

if test -f "configure.ac"; then
  echo "configure file exists. run ./configure..."
  ./configure --prefix=/usr
fi

if test -f "Makefile.in"; then
  echo "Makefile exists. Building binaries (tar/deb)..."
  make tar
  make deb
fi