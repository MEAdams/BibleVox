#!/bin/bash
# ============================================================================ #
# File   : strExtract.bash                                                     #
# Project: BibleVox                                                            #
# Date   : 2017.02.25                                                          #
# Author : MEAdams                                                             #
# Purpose: Locate all occurrences of a text string found within a specified    #
#        : bible text file. Return the scripture references where the text     #
#        : string was found. This script is inteded for locating whole         #
#        : words such as proper names. Such will be preceded by a space        #
#        : separating it from preceding text and end before specific suffix    #
#        : characters separating it from any following text.                   #
# -------:-------------------------------------------------------------------- #
# Notes &: 1. This script returns scripture references where the text is found #
# Assumes:    which are not sufficient for counting to obtain a sum total of   #
#        :    all occurances because the text might appear more than once per  #
#        :    reference (very common). Therefore, a subsequent search would    #
#        :    be necessary to find the number of occurrences per scripture     #
#        :    reference.                                                       #
# -------:-------------------------------------------------------------------- #
# Script name
scr=$(basename "$0")

# Load utility helper scripts
source ../scrhlp.bash > /dev/null 2>&1
if [ $? -gt 0 ]; then echo "ABORT: ${scr} can't find scrhlp.bash"; exit 1; fi

# User help
usage() { printf "${_eko}" "
Usage: ./${scr} txtFile strText
Where: txtFile = base name of text file to search (e.g. ESV, KJV)
       strText = string text to search for (e.g. Peter) \n
Note : quote strText of multiple words (e.g. \"Simon Peter\") \n" \
1>&2; exit 1; }

if [ -z "${1}" ]; then usage; fi
if [ -z "${2}" ]; then usage; fi

# Arguments
TXT="../Texts/${1}.copyrighted"
STR=${2}
SFX="[ .,;:]"

# Read text file
_try cat "${TXT}" | \

# Find the text string occurrences
grep -i -G " ${STR}${SFX}\| ${STR}$" | \

# Return scripture references for the occurrences
sed 's/^\(.*[0-9]*:[0-9]*:\).*/\1/g'

