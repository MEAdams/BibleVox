#!/bin/bash
# mea-2016.05.22
# Script to run festival voice regression tests

# define some directory paths
curdir=$(pwd)
scrdir=${curdir}/../Tools

# get home grown bash script helper functions and ulitities
source $scrdir/scrhlp.bash > /dev/null 2>&1

# make path to examples dir
exdir=$(pwd)/build/examples

# Run tests if festival is built
_try cd ./build/festival

# Testing festvox festival high quality voices
voices=(ahw aup awb axb bdl clb fem gka jmk ksp rms rxr slt)

for voice in ${voices[*]}
do
    name=festival_${voice}_hw.wav
    printf $_eko "Creating high quality wave: ./build/examples/${name}"

    _try ./bin/text2wave -eval "(voice_cmu_us_${voice}_cg)" \
        -o ${exdir}/${name} ${exdir}/allphones.txt
done

# Testing festvox festival basic diphone voices
voices=(kal rab)

for voice in ${voices[*]}
do
    name=festival_${voice}_hw.wav
    printf $_eko "Creating basic diphone wave: ./build/examples/${name}"

    _try ./bin/text2wave -eval "(voice_${voice}_diphone)" \
        -o ${exdir}/festival_${voice}_hw.wav ${exdir}/allphones.txt
done

cd ..
cd ..
