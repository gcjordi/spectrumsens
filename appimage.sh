#!/bin/bash

# Simple recipe to generate an appimage for this app
#
# Options:
#   * -u will upload your AppImage file after success to github under
#      "continuous builds"
#
# Requirements:
#   * VERSION as an ENV var, if not detected will use actual github
#     version + commit info
#   * This must be run after a successfully build, and need to set the
#     APP var below to the path of the executable (default is the current
#     travis build place: build/src/gqrx)
#   * Must be run on a Linux version as old as the far distro you need to
#     support, tested successfully on Ubuntu 14.04 Trusty Tar
#   * If you plan to use the "-u" option you need to configure some things
#     for it to work, check this https://github.com/probonopd/uploadtool#usage
#
# On any troubles invoke stdevPavelmc in github

# Tweak this please: this is the path of the gqrx executable relative to
#the project root will reside after build
APP="build/src/gqrx"

# No need to tweak below unless you move files on the actual project
DESKTOP="gqrx.desktop"
ICON="resources/icons/gqrx.svg"

# clean log space
echo "==================================================================="
echo "                Starting to build the AppImage..."
echo "==================================================================="
echo ""

export VERSION=$(<version.txt)

# version notice
echo "You are building Gqrx version: $VERSION"
echo ""

# basic tests
if [ ! -f "$APP" ] ; then
    echo "Error: the app file is no in the path we need it, update the APP var on this script"
    exit 1
fi

if [ ! -f "$DESKTOP" ] ; then
    echo "Error: can't find the desktop file, please update the DESKTOP var on the scriot"
    exit 1
fi

if [ ! -f "$ICON" ] ; then
    echo "Error: can't find the default icon, please update the ICON var in the script"
    exit 1
fi

# prepare the ground
rm -rdf AppDir 2>/dev/null
rm -rdf Gqrx-*.AppImage 2>/dev/null

# download & set all needed tools
wget -c -nv "https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage"
wget -c -nv "https://github.com/linuxdeploy/linuxdeploy-plugin-qt/releases/download/continuous/linuxdeploy-plugin-qt-x86_64.AppImage"
wget -c -nv "https://github.com/linuxdeploy/linuxdeploy-plugin-appimage/releases/download/continuous/linuxdeploy-plugin-appimage-x86_64.AppImage"
chmod a+x *.AppImage

# abra-cadabra
mkdir -p ./AppDir/usr/lib
cp -R /usr/lib/x86_64-linux-gnu/SoapySDR/modules* ./AppDir/usr/soapy-modules

./linuxdeploy-x86_64.AppImage -e "$APP" -d "$DESKTOP" -i "$ICON" -p qt --output appimage --appdir=./AppDir
RESULT=$?

# check build success
if [ $RESULT -ne 0 ] ; then
    # warning something gone wrong
    echo ""
    echo "ERROR: Aborting as something gone wrong, please check the logs"
    exit 1
else
    # success
    echo ""
    echo "Success build, check your file:"
    ls -lh Gqrx-*.AppImage
fi

if [ "$1" == "-u" ] ; then
    # must upload to continuous releases
    # see https://github.com/probonopd/uploadtool#usage for configs to be done
    # for this to work as needed
    wget -c https://github.com/probonopd/uploadtool/raw/master/upload.sh
    bash upload.sh Gqrx-*.AppImage
fi
