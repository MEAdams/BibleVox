#!/bin/bash
# ============================================================================ #
# File    : text_fltrs.bash                                                    #
# Project : BibleVox                                                           #
# Date    : 2017.04.04                                                         #
# Author  : MEAdams                                                            #
# Purpose : Filters for preparing Bible text for narration.                    #
# Usage   : See usage() user help function. STDOUT stream must be piped to     #
#         : the Festival speech engine using my init_speech.scm script.        #
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

# obtain requested book, chapter and verse(s) from the specified text
awk -F: -v bc="$bc" -v fv="$fv" -v lv="$lv" '$1==bc && $2>=fv && $2<=lv' \
    ../Tools/Texts/"${tx}".copyrighted | \

# pipe text to be displayed to book and chapter number filter
sed s/"${bc}:"/""/g | \

# pipe text to be displayed to new line character filter
tr '\n' ' ' | \

# display text to be spoken with word-wrapped lines
fold -s -w "${col}" | tee /dev/tty | \

# pipe text to be spoken to verse number filter
sed s/[0-9][0-9]*:/""/g | \

# pipe text to be spoken to square bracket filter
sed s/[\[\]]*/''/g | \

# pipe text to be spoken to extended character code filter
../Tools/utf2ascii.bash

# skip a line for next displayed text
printf ${_eko} "\n" 1>&2
