#!/bin/bash
# mea-2016.05.22
# Script to obtain the festival and speech tools software

# define some directory paths
curdir=$(pwd)
scrdir=${curdir}/../Tools

# get home grown bash script helper functions and ulitities
source $scrdir/scrhlp.bash > /dev/null 2>&1

_try cd packed

# Respository location
rpstry="http://www.festvox.org/packed/festival/2.4/"

# Get the festival and speech tools software

_try wget ${rpstry}festival-2.4-release.tar.gz
_try wget ${rpstry}speech_tools-2.4-release.tar.gz

cd ..

