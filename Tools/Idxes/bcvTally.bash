#!/bin/bash
# ============================================================================
# File    : bcvTally.bash
# Project : BibleVox
# Date    : 2016.06.24
# Author  : MEAdams
# Purpose : scan bible text and create a book, chapter and verse lookup table
# --------:-------------------------------------------------------------------
# Depends : 1. Either pre-extracted Bible text file or diatheke application
# --------:-------------------------------------------------------------------
# Notes & : 1. The number of books, their names, numbers of chapters and
# Assumes :    verses can differ among bible translations, printed texts and
#         :    electronic texts. This script produces a precise table to be
#         :    associated with a specific electronic rendering of the bible.
#         :    Any bible text accessible to the CrossWire "diatheke" command
#         :    line SWORD project frontend can be scanned using this script
#         :    to produce a table suitable for use within software needing
#         :    access to such information.
# --------:-------------------------------------------------------------------
# To Do   : 1. 
# ============================================================================
# Script name
scr=$(basename "$0")

# Load utility helper scripts
source ../scrhlp.bash > /dev/null 2>&1
if [ $? -gt 0 ]; then echo "ABORT: ${scr} can't find scrhlp.bash"; exit 1; fi

# User help
usage() { printf "${_eko}" "
Usage: ./${scr} txtFile
Where: prjName = diatheke -b module name argument (e.g. ESV, KJV) \n" \
1>&2; exit 1; }

if [ -z "${1}" ]; then usage; fi

# Text file base name argument
PRJ="${1}"

# initializations
BCV="./${PRJ}bcv.menu"
LOG="./${PRJ}tmp.log"
TXT="../Texts/${PRJ}.copyrighted"
fmt="%-20s%-4d%s\n"

# clear any old files for a new run
cat /dev/null > "${BCV}"
cat /dev/null > "${LOG}"

# retrieve all book names and chapter numbers for requested translation
# Alternately can be done with diatheke if text file not available (slower)
# diatheke -b ${PRJ} -k Genesis - | \
cat "${TXT}" | \
    sed -e 's/^III /3 /' -e 's/^II /2 /' -e 's/^I /1 /' | \
    grep -o -G '^[1-3]* *[a-Z ]* [0-9]*:[0-9]*' > "${LOG}"

oldbook=""
oldchap=""
oldvers=""
versarr=""
passflg=""
while read line || [[ -n "$line" ]]; do

    chppart=$(echo `expr "$line" : '^[1-3]* *[a-Z ]*'`)
    verpart=$(echo `expr "$line" : '^.*[0-9]*:'`)
    chpwdth=$(( $verpart - $chppart -1 ))

    newbook=$( echo $(echo `expr "$line" : '^\([1-3]* *[a-Z ]*\)'`) | \
        sed 's/ //g')
    newchap=$(echo ${line:$chppart:$chpwdth})
    newvers=$(echo ${line:$verpart})

    # get book name
    if [[ "${newbook}" = "${oldbook}" ]]
    then
        # get number of chapters in book
        if [[ ${newchap} -lt ${oldchap} ]]
        then
            oldchap=0
        else
            # get number of verses in chapter
            if [[ ${newvers} -lt ${oldvers} ]]
            then
                versarr="${versarr} ${oldvers}"        
                oldvers=0
            else
                oldvers="${newvers}"
            fi
            oldchap="${newchap}"
        fi
    else
        versarr="${versarr} ${oldvers}"        
        [[ ${passflg} -eq 1 ]] && \
            printf "$fmt" "${oldbook}" "${oldchap}" "${versarr}" >> "${BCV}"
        ! [[ ${newbook} = "" ]] && oldbook="${newbook}"
        ! [[ ${newchap} = "" ]] && oldchap="${newchap}"
        ! [[ ${newvers} = "" ]] && oldvers="${newvers}"
        versarr=""
        passflg=1
    fi
done < "${LOG}"

# program logic holds last results after EOF, so print it as well
[[ ${?} -eq 0 ]] && rm "${LOG}"
printf "$fmt" "${oldbook}" "${oldchap}" "${versarr} ${oldvers}" >> "${BCV}"
