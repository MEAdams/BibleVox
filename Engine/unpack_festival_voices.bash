#!/bin/bash
# ============================================================================ #
# File   : unpack_festival_voices.bash                                         #
# Project: BibleVox                                                            #
# Date   : 2016.05.01                                                          #
# Author : MEAdams                                                             #
# Purpose: Script to unpack the festvox festival voices                        #
# ============================================================================ #
# define some directory paths
curdir=$(pwd)
scrdir=${curdir}/../Tools

# get home grown bash script helper functions and ulitities
source $scrdir/scrhlp.bash > /dev/null 2>&1

_try cd build

# Unpack festvox festival high quality voices
voices=(ahw aup awb axb bdl clb fem gka jmk ksp rms rxr slt)

for voice in ${voices[*]}
do
    _try tar zxvf ../packed/festvox_cmu_us_${voice}_cg.tar.gz
done

# Unpack festvox festival basic diphone voices
voices=(kal rab)

for voice in ${voices[*]}
do
    _try tar zxvf ../packed/festvox_${voice}lpc16k.tar.gz
done

# Unpack festvox festival voice dictionary support
_try tar zxvf ../packed/festlex_CMU.tar.gz
_try tar zxvf ../packed/festlex_OALD.tar.gz
_try tar zxvf ../packed/festlex_POSLEX.tar.gz

_try mkdir examples
echo "A whole joy was reaping, but they've gone south, \
you should fetch azure mike." > examples/allphones.txt

cd ..
