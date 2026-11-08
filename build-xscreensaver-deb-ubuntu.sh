#!/bin/bash
set -e

BLUE='\033[0;34m'
WHITE='\033[0;37m'
RED='\033[0;31m'
GREEN='\033[0;32m'
BRORANGE='\033[0;33m'

echo -e "${GREEN}Updating repositories..."
sudo apt-get update

echo -e "${GREEN}Updating packages..."
sudo apt-get upgrade -y

echo -e "${GREEN}Install dependencies..."
sudo apt-get install -y curl wget

LATEST_DOWNLOAD_FILENAME=`curl -s -A "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36" https://www.jwz.org/xscreensaver/download.html | grep "xscreensaver-" | grep "tar.gz" | cut -d '"' -f 4 | head -n 1`
LATEST_DOWNLOAD_URL_BASEPATH="https://www.jwz.org/xscreensaver/"
LATEST_DOWNLOAD_URL=$LATEST_DOWNLOAD_URL_BASEPATH$LATEST_DOWNLOAD_FILENAME
DOWNLOAD_FOLDER="$HOME/Downloads"
#DOWNLOAD_FOLDER="."
DOWNLOADED_FILEPATH="${DOWNLOAD_FOLDER}/${LATEST_DOWNLOAD_FILENAME}"
EXTRACTED_FOLDER_NAME=`basename -s .tar.gz ${LATEST_DOWNLOAD_FILENAME}`
EXTRACTED_FOLDERPATH="${DOWNLOAD_FOLDER}/${EXTRACTED_FOLDER_NAME}/"
LATEST_DOWNLOAD_VERSION=`echo "${EXTRACTED_FOLDER_NAME}" | cut -d "-" -f 2`
LATEST_DOWNLOAD_VERSION_MAJOR=`echo "${EXTRACTED_FOLDER_NAME}" | cut -d "-" -f 2 | cut -d "." -f 1`
LATEST_DOWNLOAD_VERSION_MINOR=`echo "${EXTRACTED_FOLDER_NAME}" | cut -d "-" -f 2 | cut -d "." -f 2`

if [ -z "$LATEST_DOWNLOAD_FILENAME" ]; then
  echo -e "${RED}Error: Could not scrape the latest filename. The website layout may have changed."
  exit 1
else
  echo "${GREEN}Latest version is: ${WHITE}${LATEST_DOWNLOAD_VERSION}"
fi

if ! test -d "${DOWNLOAD_FOLDER}"; then
  mkdir "${DOWNLOAD_FOLDER}"
  cd "${DOWNLOAD_FOLDER}"
else
  cd "${DOWNLOAD_FOLDER}"
fi

if ! test -f "${DOWNLOADED_FILEPATH}"; then
  echo -e "${GREEN}latest xscreensaver tarball doesn't exist. Downloading..."
  wget -c "${LATEST_DOWNLOAD_URL}"
fi

#echo $EXTRACTED_FOLDER_NAME
#echo $EXTRACTED_FOLDERPATH
#exit

if test -d "${EXTRACTED_FOLDERPATH}"; then
  echo -e "${GREEN}Latest tarball has already been extracted."
  read -p "Do you want to delete the existing folder and start over? (y/n) " yn

  case $yn in
    [yY] ) echo -e "${GREEN}OK, deleting existing extracted folder."
            rm -rf "${EXTRACTED_FOLDERPATH}" ;;
    [nN] ) echo -e "${RED}Exiting..."
            exit;;
    * ) echo -e "${WHITE}Invalid respone, exiting..."
            exit;;
  esac
fi

if test -f "${DOWNLOADED_FILEPATH}"; then
  echo -e "${GREEN}xscreensaver tarball exists. Extracting..."
  tar zxf "${DOWNLOADED_FILEPATH}"
  #ls -alh $EXTRACTED_FOLDERPATH
fi
#exit

echo -e "${GREEN}Installing build dependencies..."
sudo apt-get install -y build-essential fakeroot debhelper

if test -d "${EXTRACTED_FOLDERPATH}"; then
  cd "${EXTRACTED_FOLDERPATH}"
  echo -e "${GREEN}xscreensaver tarball extracted folder exists. Installing dependencies..."
  if ! sudo apt-get build-dep -y . ; then
    echo -e "${RED}ERROR: Failed to get build dependencies."
    echo -e "${BRORANGE}Either the debian folder is not in the tarball or 'Source code' (deb-src) repositories are disabled."
    echo -e "${BRORANGE}Enabling 'Source code' (deb-src) repositories in your Software & Updates settings may fix this problem."
    exit 1
  fi
fi

if test -f "configure"; then
  echo -e "${GREEN}configure file exists. run ./configure..."
  ./configure --prefix=/usr
fi

if test -f "Makefile"; then
  echo -e "${GREEN}Makefile exists. Building binaries (tar/deb)..."
  make tar
  make deb
fi