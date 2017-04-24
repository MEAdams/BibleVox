#!/bin/bash
# ============================================================================ #
# File    : bible.bash                                                         #
# Project : BibleVox                                                           #
# Date    : 2016.05.26                                                         #
# Author  : MEAdams                                                            #
# Purpose : Bible narration application.                                       #
# Usage   : See usage() user help function.                                    #
# --------:------------------------------------------------------------------- #
# Depends : 1. ism.bash, scrhlp.bash, text_fltrs.bash, init_speech.scm,        #
#         :    txtExtract.bash, Diatheke                                       #
# --------:------------------------------------------------------------------- #
# Notes & : 1. Diatheke 4.7 remains broken in Ubuntu 16.04 despite my bug      #
# Assumes :    reports. It repeats the last verse requested minus the verse    #
#         :    reference. Therefore, my BibleVox development was continued     #
#         :    by using my text_fltrs.bash script. The text files needed for   #
#         :    said script are able to be extracted from CrossWire modules     #
#         :    by using my txtExtract.bash script (which uses Diatheke). The   #
#         :    resulting text files are copyrighted and are not able to be     #
#         :    duplicated or distributed for any purpose.                      #
#         : 2. I have switched back to using Diatheke because my correction    #
#         :    filtering seems to have achieved 100% correction. Diatheke 4.7  #
#         :    remains broken on Ubuntu 16.04, however.                        #
#         : 3. Set dflg=1 to use Diatheke, Set dflg=0 to use text_fltrs.       #
# --------:------------------------------------------------------------------- #
# To Do   : 1. Fix Diatheke for Ubuntu 16.04.                                  #
# ============================================================================ #
# diatheke/text_fltrs switch (i.e. 1=diatheke, 0=text_fltrs).
dflg=1

# script name
scr=$(basename "$0")

# current working directory
curdir=$(pwd)

# export environment for ism.bash
export ISMAPP=${curdir}
export ISMDIR=$(cd "${ISMAPP}/../Tools" && pwd)

# load utility helper scripts
source ../Tools/scrhlp.bash > /dev/null 2>&1
if [ $? -gt 0 ]; then echo "ABORT: ${scr} can't find scrhlp.bash"; exit 1; fi

# user help
usage()
{ printf ${_eko} "
Usage: ./${scr} text \n
Where: text = base name of Bible text (e.g. ESV, KJV) \n" 1>&2; exit 1; }

# missing arguments trap
if [ $# -eq 0 ]; then usage; fi

# base name of Bible text
TEXT="${1}"

# initializations
done=0; chr=""; row=2; col=0; ESC=27; BIDX=0; CIDX=1

# main user interaction loop
while [[ ${done} -ne ${ESC} ]]
do
    if [[ ${chr} = "" ]]
    then
        # get selection
        _try ${ISMDIR}/ism.bash Idxes/${TEXT}bcv.menu "Enter bible book: "

        # retrieve selection ism parameters
        ISMPARS=( $(cat ism.vars) )

        # get selected book name
        BOOK=$(echo "${ISMPARS[$BIDX]}" | \
            sed 's/[123]/& /' | sed 's/SongofSolomon/Song of Solomon/' | \
            sed 's/RevelationofJohn/Revelation of John/' )

        # test for quit request
        if [[ "${BOOK}" = "ISM-ESC" ]]
        then
            cat /dev/null > ./ism.vars
            printf "${_eko}" "\n\n Later, God willing. \n"
            exit 0
        fi
        echo

        # maximum number of chapters for selected book
        CMAX="${ISMPARS[$CIDX]}"

        # get book chapter number
        unset CHAP
        while [[ ! ${CHAP} =~ ^[0-9]+$ ]]; do
            read -p "Enter a chapter number [1..$CMAX]: " CHAP
            ! [[ ${CHAP} -ge 1 && ${CHAP} -le ${CMAX} ]] && unset CHAP
        done

        # maximum number of verses for selected chapter
        VMAX="${ISMPARS[(( $CIDX + $CHAP ))]}"

        # get chapter verse(s)
        unset VERS
        while [[ ! ${VERS} =~ ^[0-9]+[-]*[0-9]*$ ]]; do
            read -p "Verse (# or #-# or Enter) [1-$VMAX]: " VERS
            if [[ ${VERS} = "" ]]
            then
                VERS="1-$VMAX"
            fi

            if [[ $(_ismpart "${VERS}") -gt 0 ]]
            then
                FRST=$(_ismLpart "${VERS}")
                LAST=$(_ismRpart "${VERS}")
                ! [[ ${FRST} -ge 1 && \
                     ${FRST} -le ${LAST} ]] && unset VERS
                ! [[ ${LAST} -ge ${FRST} && \
                     ${LAST} -le ${VMAX} ]] && unset VERS
            else
                FRST="${VERS}"
                LAST="${VERS}"
                ! [[ ${FRST} -ge 1 && \
                     ${FRST} -le ${VMAX} ]] && unset VERS
            fi
        done
    fi

    # narration
    if [[ dflg -eq 1 ]]
    then
    # using diatheke application
        ./sword_speak.bash \
            -t "${TEXT}" -b "${BOOK}" -c "${CHAP}" -f "${FRST}" -l "${LAST}" | \
        ./init_speech.scm
    else
    # using text_fltrs utility
        ./text_fltrs.bash \
            -t "${TEXT}" -b "${BOOK}" -c "${CHAP}" -f "${FRST}" -l "${LAST}" | \
        ./init_speech.scm
    fi

    # wait for user command
    printf $_eko \
        "<SPACE> repeat, <ENTER> continue, <ESC> exit, <Ctrl-C> abort:\n"
    _readchar chr
    printf -v done "%d" "'${chr}"
    if [ $(pidof festival) ]
    then
        pkill festival
        done=0
        chr=""
    fi
    $_clr
done

# ensure speech engine is killed
pkill festival
$_clr
