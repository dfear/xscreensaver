#!/bin/bash
set -e

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
  echo "Error: Could not scrape the latest filename. The website layout may have changed."
  exit 1
else
  echo "Latest version is: ${LATEST_DOWNLOAD_VERSION}"
fi

if ! test -d "${DOWNLOAD_FOLDER}"; then
  mkdir "${DOWNLOAD_FOLDER}"
  cd "${DOWNLOAD_FOLDER}"
else
  cd "${DOWNLOAD_FOLDER}"
fi

if ! test -f "${DOWNLOADED_FILEPATH}"; then
  echo "latest xscreensaver tarball doesn't exist. Downloading..."
  wget -c "${LATEST_DOWNLOAD_URL}"
fi

#echo $EXTRACTED_FOLDER_NAME
#echo $EXTRACTED_FOLDERPATH
#exit

if test -d "${EXTRACTED_FOLDERPATH}"; then
  echo "Latest tarball has already been extracted."
  read -p "Do you want to delete the existing folder and start over? (y/n) " yn

  case $yn in
    [yY] ) echo "OK, deleting existing extracted folder."
            rm -rf "${EXTRACTED_FOLDERPATH}" ;;
    [nN] ) echo "Exiting..."
            exit;;
    * ) echo "Invalid respone, exiting..."
            exit;;
  esac
fi

if test -f "${DOWNLOADED_FILEPATH}"; then
  echo "xscreensaver tarball exists. Extracting..."
  tar zxf "${DOWNLOADED_FILEPATH}"
  #ls -alh $EXTRACTED_FOLDERPATH
fi
#exit

sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y build-essential fakeroot debhelper

if test -d "${EXTRACTED_FOLDERPATH}"; then
  cd "${EXTRACTED_FOLDERPATH}"
  echo "xscreensaver tarball extracted folder exists. Installing dependencies..."
  sudo apt-get build-dep -y .
fi

if test -f "configure"; then
  echo "configure file exists. run ./configure..."
  ./configure --prefix=/usr
fi

if test -f "Makefile"; then
  echo "Makefile exists. Building binaries (tar/deb)..."
  make tar
  make deb
fi