#!/bin/bash
# mea-2016.05.22
# Script to obtain the Ubuntu/Debian festival software

# define some directory paths
curdir=$(pwd)
scrdir=${curdir}/../Tools

# get home grown bash script helper functions and ulitities
source $scrdir/scrhlp.bash > /dev/null 2>&1

_try cd build

# Unpack the Ubuntu/Debian festival software

_try tar Jxvf ../packed/festival_2.4~release-2.debian.tar.xz

cd ..

