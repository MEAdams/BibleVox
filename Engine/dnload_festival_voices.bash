#!/bin/bash
# ============================================================================ #
# File   : dnload_festival_voices.bash                                         #
# Project: BibleVox                                                            #
# Date   : 2016.05.01                                                          #
# Author : MEAdams                                                             #
# Purpose: Script to obtain the festvox festival voices                        #
# ============================================================================ #
# define some directory paths
curdir=$(pwd)
scrdir=${curdir}/../Tools

# get home grown bash script helper functions and ulitities
source $scrdir/scrhlp.bash > /dev/null 2>&1

_try cd packed

# Repository location
rpstry="http://www.festvox.org/packed/festival/2.4/"

# Get festvox festival high quality voices
voices=(ahw aup awb axb bdl clb fem gka jmk ksp rms rxr slt)

for voice in ${voices[*]}
do
    _try wget ${rpstry}voices/festvox_cmu_us_${voice}_cg.tar.gz
done

# Get festvox festival basic diphone voices
voices=(kal rab)

for voice in ${voices[*]}
do
    _try wget ${rpstry}voices/festvox_${voice}lpc16k.tar.gz
done

# Get festvox festival voice dictionary support
_try wget ${rpstry}festlex_CMU.tar.gz
_try wget ${rpstry}festlex_OALD.tar.gz
_try wget ${rpstry}festlex_POSLEX.tar.gz

cd ..
