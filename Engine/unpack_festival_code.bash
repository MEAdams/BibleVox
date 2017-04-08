#!/bin/bash
# mea-2016.05.22
# Script to unpack the festival and speech tools software

# define some directory paths
curdir=$(pwd)
scrdir=${curdir}/../Tools

# get home grown bash script helper functions and ulitities
source $scrdir/scrhlp.bash > /dev/null 2>&1

_try cd build

# Unpack the festival and speech tools software

_try tar zxvf ../packed/festival-2.4-release.tar.gz
_try tar zxvf ../packed/speech_tools-2.4-release.tar.gz

cd ..

