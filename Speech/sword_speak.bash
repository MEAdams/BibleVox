#!/bin/bash
# ============================================================================ #
# File    : sword_speak.bash                                                   #
# Project : BibleVox                                                           #
# Date    : 2016.05.24                                                         #
# Author  : MEAdams                                                            #
# Purpose : Filter Diatheke bible text output suitable for Festival narration. #
# Usage   : See usage() user help function. STDOUT stream must be piped to the #
#         : Festival speech engine using my init_speech.scm script.            #
# --------:------------------------------------------------------------------- #
# Notes & : 1. Ubuntu 16.04 LTS, diatheke 1.7.3+dfsg-7 has a bug. However,     #
# Assumes :    Ubuntu 14.04 LTS, diatheke 1.6.2+dfsg-6build1 did not have      #
#         :    this bug. The last verse requested is repeated following a      #
#         :    colon with no preceding number. This script attempts to filter  #
#         :    the contamination out. However, I cannot be certain that the    #
#         :    filter is 100% effective.                                       #
# --------:------------------------------------------------------------------- #
# To Do   : 1. Fix Diatheke for Ubuntu 16.04.                                  #
# ============================================================================ #
# script name
scr=$(basename "$0")

# load utility helper scripts
source ../Tools/scrhlp.bash > /dev/null 2>&1
if [ $? -gt 0 ]; then echo "ABORT: ${scr} can't find scrhlp.bash"; exit 1; fi

# user help
usage()
{ printf ${_eko} "
Usage: ./${scr} -t text -b book -c chapter -f first -l last \n
Where: text    = base name of Bible text file (e.g. ESV, KJV)
       book    = name of book
       chapter = chapter number
       first   = number of first verse in range
       last    = number of last verse in range \n" 1>&2; exit 1; }

# missing arguments trap
if [ $# -eq 0 ]; then usage; fi

# process command line arguments
tx=""; bk=""; ch=""; fv=""; lv=""
while getopts ":t:b:c:f:l:" opt; do
    case "${opt}" in
	t)
            tx="${OPTARG}"
            if [ -z "${tx}" ]; then usage; fi
            ;;
        b)
            bk="${OPTARG}"
            if [ -z "${bk}" ]; then usage; fi
            ;;
        c)
            ch="${OPTARG}"
            if [ -z "${ch}" ]; then usage; fi
            ;;
        f)
            fv="${OPTARG}"
            if [ -z "${fv}" ]; then usage; fi
            ;;
        l)
            lv="${OPTARG}"
            if [ -z "${lv}" ]; then usage; fi
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

# specify displayed text word-wrap column
col=70

# format selection specification
num=$( echo "${bk}" | sed 's/^\([123]\).*/\1/' )
nam=$( echo "${bk}" | sed 's/^[123][ ]*//' )
case "${num}" in
    1 )
        num="First"
        bk="I ${nam}"
        ;;
    2 )
        num="Second"
        bk="II ${nam}"
        ;;
    3 )
        num="Third"
        bk="III ${nam}"
        ;;
    * ) num=""
        ;;
esac

# create book/chapter filter pattern
bc="${bk} ${ch}"

# create announcement strings
if [[ "${fv}" -eq "${lv}" ]]
then
    say="${num} ${nam}, Chapter ${ch}, Verse ${fv}:"
    see="${bc}:${fv}"
else
    say="${num} ${nam}, Chapter ${ch}, Verse ${fv} to Verse ${lv}:"
    see="${bc}:${fv}-${lv}"
fi

# display selection
printf ${_eko} "\n${see}\n" 1>&2

# announce selection
printf ${_eko} "${say}"

# Sword database lookup:
_try diatheke -f plain -b ${tx} -k "${bc}:${fv}-${lv}" | \

# reformat diatheke output for display and speech processing
../Tools/verseperline.bash | \

# The following attempts to correct for the Diatheke bug. I'm not sure it is
# 100% effective. This filter should not affect the output of a properly
# working diatheke program.
sed s/" : ".*/""/g | \

# pipe text to be displayed to book and chapter number filter
sed s/"${bc}":/""/g | \

# pipe text to be displayed to new line character filter
tr '\n' ' ' | \

# display text to be spoken with word-wrapped lines
fold -s -w ${col} | tee /dev/tty | \

# pipe text to be spoken to verse number filter
sed s/[0-9][0-9]*:/""/g | \

# pipe text to be spoken to square bracket filter
sed -e "s/]//g" -e "s/\[//g" | \

# pipe text to be spoken to extended character code filter
../Tools/utf2ascii.bash

# skip a line for next text to be displayed
printf ${_eko} "\n" 1>&2
