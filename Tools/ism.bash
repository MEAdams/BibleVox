#!/bin/bash
# ============================================================================
# File    : ism.bash
# Project : BibleVox
# Date    : 2016.05.26
# Author  : MEAdams
# Purpose : ism (Interactive Shell Menu) is a console script menu facility
# --------:-------------------------------------------------------------------
# Depends : 1. An application menu definition file (ism.menu)
#         : 2. Env vars ISMDIR and ISMAPP exported by the application
# --------:-------------------------------------------------------------------
# Notes & : 1. ism is not a "pointy-clicky-thing". It manages a console menu.
# Assumes : 2. No attempt has been made to eliminate "bashisms"
# --------:-------------------------------------------------------------------
# To Do   : 1. 
# ============================================================================
# local identity
scr=$(basename "$0")

# load utility helper scripts
source ${ISMDIR}/scrhlp.bash > /dev/null 2>&1
if [ $? -gt 0 ]; then echo "ABORT: ${scr} can't find scrhlp.bash"; exit 1; fi

# User help
usage() { printf "${_eko}" "
Usage: ./${scr} mnuFile pmtText
Where: mnuFile = a dictionary file (e.g. BibleVoxDict)
       pmtText = user prompt text (e.g. \"Enter search word: \") \n" \
1>&2; exit 1; }

if [ -z "${1}" ]; then  usage; fi
if [ -z "${2}" ]; then  usage; fi

# Build full mnuFile path
ISM="${ISMDIR}/${1}"
PRT="${2}"

# variable initializations
len=${#PRT}; row=0; col=${len}; cnt=0; chr=""; code=""; wrd=""

$_clr  # clear console screen buffer

while  [[ cnt -ne 1 ]]
do
    oset=${#wrd}
    tput cup ${row} 0; printf "\r%s" "${PRT}"
    tput cup ${row} ${col}; printf "%s" "${wrd}"
    tput cup ${row} $(( ${col} + ${oset} ))

    # read a single character (return its ascii decimal code)
    code=$( _readcode )

    # check OCTAL character codes:
    case $code in
        0  )
            # Selection made
            #tput cup ${row} ${col}; tput el
            tput cup ${row} ${col}; tput ed
            break
            ;;
        27 )
            # ESC
            echo "ISM-ESC" > $ISMAPP/ism.vars; exit 0
            ;;
        127 )
            # Backspace (i.e. delete left)
            wrd=${wrd%?}; code=""
            ;;
        * )
            # ascii decimal codes for a-z, A-Z, 1-9, " ", "'", "-", "_"
            # (because, this is the only way to get the "'" character)
            if ((97 <= $code && $code <= 122)) || \
               ((65 <= $code && $code <=  90)) || \
               ((49 <= $code && $code <=  57)) || \
               (($code == 32)) || (($code == 39)) || \
               (($code == 45)) || (($code == 95))
            then
                # convert the allowed ascii decimal code to a character
                chr=$( printf \\$(printf '%03o' $code ))
                wrd="${wrd}${chr}"
            fi
    esac

    tput cup ${row} ${col}; tput ed

    if [[ ! -z ${wrd} ]]
    then
        cat "${ISM}" | sort -k1,1 | awk '{ print $1 }' | \
            grep --color=always -i -G "^${wrd}" | \
            tr '\n' '@' | sed 's/@/  /g'
    fi
done

# clear the console and redisplay the ism input prompt
$_clr
tput cup ${row} 0; printf "\r%s" "${PRT}"

# build a menu file index from the selected ism word (line:word)
idx=$( cat "${ISM}" | sort -k1,1 | awk '{ print $1 }' | \
    grep -n -m 1 -i -G "^${wrd}" )

# share the selected ism menu file line contents
echo $( cat "${ISM}" | sort -k1,1 | head -$(_ismLpart  $idx ) | \
    tail -1) > $ISMAPP/ism.vars

# print the selected ism menu file word
tput cup ${row} ${col}; _ismRpart $idx | \
sed 's/[123]/& /' | sed 's/SongofSolomon/Song of Solomon/' | \
sed 's/RevelationofJohn/Revelation of John/'
