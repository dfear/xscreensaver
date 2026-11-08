# Un-official XScreensaver repository

## There is no official XScreenSaver GitHub repository

I am NOT [jwz](https://www.jwz.org/), the author of [XScreenSaver](https://www.jwz.org/xscreensaver/), and he does not publish a public source code repository. [jwz](https://www.jwz.org/) publish releases as tar files on the [official web site](https://www.jwz.org/xscreensaver/) and only there.

This XScreenSaver repository (on GitHub) has nothing to do with [jwz](https://www.jwz.org/). You should only trust downloads from the offical website.

[jwz](https://www.jwz.org/) welcomes submissions and change requests via [email](mailto:jwz@jwz.org?subject=XScreenSaver%20has%20no%20git%20repo).

## Purpose

The purpose of this repository is to serve as a place to download a script that can be used on Debian or Ubuntu to build a debian package from the official source tarball.

The purpose of the script is to download and buid a debian package only! It does NOT install the built package or check if your system has the required dependences (for the built package).

## How to use the script

1. open a terminal and chnage to a directory where you want to clone this repository to.
2. Install `git` (if you don't already have it), by typing: `sudo apt-get install -y git`
3. clone the repository by typying: `git clone https://github.com/dfear/xscreensaver.git`
4. If `build-xscreensaver-deb-ubuntu.sh` is not executable, make it so by typing: `chmod +x build-xscreensaver-deb-ubuntu.sh`
5. run the script, by typing: `./build-xscreensaver-deb-ubuntu.sh`.

## FAQs

1. Where are the packages the script builds?
A. They are in `<DOWNLOAD_FOLDER>/xscreensaver-<MAJOR>.<MINOR>/debian/build`.
wg: `$HOME/Downloads/xscreensaver-6.17/debian/build`.

## Notes

### On Ubuntu

You might need to uninstall packages before you can install `xscreensaver-*.*.deb`

Uninstall all exitsting xscreensaver packages such as:
`xscreensaver-data`
`xscreensaver-glextras`
etc

Also may also need to install:
`attr` or `xattr`

## todo

Add support for:

1. checking if a tarball already exists. DONE
2. checking if the latest tarball is newer than the existing tarball. DONE
3. if latest tarball is newer than exising, DONE
   1. delete existing tarball. DONE
   2. delete existing extracted tarball folder. DONE
   3. then download latest tarball. DONE
4. if existing tarball is the same as latest tarball, exit the script. DONE

I believe all of the above are now implemented.
