#!/bin/bash
# ============================================================================ #
# File   : build_festival.bash                                                 #
# Project: BibleVox                                                            #
# Date   : 2016.05.01                                                          #
# Author : MEAdams                                                             #
# Purpose: Script to build the festival application software. Ubuntu 16.04     #
#        : installs package "build-essential" by default. However, must also   #
#        : run: sudo apt-get install libncurses5-dev                           #
# ============================================================================ #
# define some directory paths
curdir=$(pwd)
scrdir=${curdir}/../Tools

# get home grown bash script helper functions and ulitities
source $scrdir/scrhlp.bash > /dev/null 2>&1

# make/reuse log files (use is optional via command line redirection)
touch bldout.log; cat /dev/null > bldout.log
touch blderr.log; cat /dev/null > blderr.log

printf $_eko "\*** Festival software build initiated\n"

# is everything already down-loaded
if [ ! -d packed ]
then  # if not...
    _try mkdir packed

    printf $eko "\n*** Dnloading festival speech engine software\n"
    _try ./dnload_festival_code.bash

    printf $eko "\n*** Dnloading festival speech engine voices\n"
    _try ./dnload_festival_voices.bash

    printf $eko "\n*** Dnloading Ubuntu/Debian installation mods\n"
    _try ./dnload_ubuntu_mods.bash
fi

# is everything already unpacked
if [ ! -d build ]
then  # if not...
    _try mkdir build

    printf $eko "\n*** Unpacking festival speech engine software\n"
    _try ./unpack_festival_code.bash

    printf $eko "\n*** Unpacking festival speech engine voices\n"
    _try ./unpack_festival_voices.bash

    printf $eko "\n*** Unpacking Ubuntu/Debian installation mods\n"
    _try ./unpack_ubuntu_mods.bash
fi

# ready to build
_try cd build

# Set up necessary environment variables for the build process
export ESTDIR=${PWD}/speech_tools
export FESTIVAL_HOME=${PWD}/festival

printf $_eko "\n*** Building Edinburgh speech tools library\n"
_try cd speech_tools
_try ./configure
_try make
_try make test
cd ..

printf $_eko "\n*** Building festival speech engine\n"
_try cd festival
_try ./configure
_try make
_try make test
cd ..

cd ..

printf $_eko "\n*** Building test festival voice waves\n"
_try ./run_festival_tests.bash

printf $_eko "\n*** Festival software build completed\n"
