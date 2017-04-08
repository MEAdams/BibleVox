#!/bin/bash
# ============================================================================
# File    : dictionary.bash
# Project : BibleVox
# Date    : 2016.06.13
# Author  : MEAdams
# Purpose : speaking dictionary lexicon development application
# --------:-------------------------------------------------------------------
# Depends : 1. ism.bash, scrhlp.bash
# --------:-------------------------------------------------------------------
# Notes & : 1.
# Assumes : 
# --------:-------------------------------------------------------------------
# To Do   : 1.
# ============================================================================
# local identity
scr=$(basename "$0")

# define the working directory environment
curdir=$(pwd)

# define ism.bash environment
export ISMAPP=${curdir}
export ISMDIR=$(cd "${ISMAPP}/../Tools" && pwd)

# load utility helper scripts
source ${ISMDIR}/scrhlp.bash > /dev/null 2>&1
if [ $? -gt 0 ]; then echo "ABORT: ${scr} can't find scrhlp.bash"; exit 1; fi

# User help
usage() { printf "${_eko}" "
Usage: ./${scr} mnuFile
Where: mnuFile = subdir/mnuName.menu (e.g. Lexes/BibleVoxDict.menu) \n" \
1>&2; exit 1; }

if [ -z "${1}" ]; then usage; fi

# the dictionary menu file
MNU="${1}"

# initializations
quit=0; chr=""; ESC=27; WIDX=0; TIDX=1; GIDX=2; NIDX=3; CIDX=4

# cursor locations
PRMPTrow=0; PRMPTcol=0
INPUTrow=6; INPUTcol=0
FINSHrow=8; FINSHcol=0
POSTGrow=2; POSTGcol=0
GUIDErow=2; GUIDEcol=10
NOTESrow=2; NOTEScol=45
CLASSrow=2; CLASScol=80
PHONErow=4; PHONEcol=0

while [[ ${quit} -ne ${ESC} ]]
do
    if [[ ${chr} = "" ]]
    then
        # get selection
        tput cup ${PRMPTrow} ${PRMPTcol}
        _try $ISMDIR/ism.bash "${MNU}" "Enter search word: "

        # retrieve selection ism parameters
        ISMPARS=( $(cat ism.vars) )

        # get selection word
        WORD=$(echo "${ISMPARS[$WIDX]}")

        # exit test
        tput cup ${FINSHrow} ${FINSHcol}
        if [[ "${WORD}" = "ISM-ESC" ]]
        then
            cat /dev/null > ./ism.vars
            printf $_eko "\n\nLater, God willing. \n"
            exit 0
        fi
        chr=" "

        # get selection pronunciation guide
        POSTG=$(echo "${ISMPARS[$TIDX]}")
        tput cup ${POSTGrow} ${POSTGcol}
        printf $_eko ${POSTG}
        GUIDE=$(echo "${ISMPARS[$GIDX]}")
        tput cup ${GUIDErow} ${GUIDEcol}
        printf $_eko ${GUIDE}
	NOTES=$(echo "${ISMPARS[$NIDX]}")
	tput cup ${NOTESrow} ${NOTEScol}
        printf $_eko ${NOTES}
        CLASS=$(echo "${ISMPARS[$CIDX]}")
	tput cup ${CLASSrow} ${CLASScol}
        printf $_eko ${CLASS}	
    fi

    if [[ ${chr} = " " ]]
    then
        # speak word and get arpabet rendering
        str="'"${WORD}"'"
        tput cup ${PHONErow} ${PHONEcol}
        echo "(arpabet ${str} t)" | ./init_voice.scm
	tput el1  # erase the "siod>" prompt returned by festival
    fi

    # wait for command
    tput cup ${INPUTrow} ${INPUTcol}
    printf "%s" "<SPACE> repeat, <ENTER> continue <ESC> quit: "
    _readchar chr
    printf -v quit "%d" "'${chr}"

    # exit test
    tput cup ${FINSHrow} ${FINSHcol}        
    if [[ ${quit} = ${ESC} ]]
    then
        cat /dev/null > ./ism.vars
        printf $_eko "\n\nLater, God willing. \n"
        exit 0
    fi
done
