#!/bin/bash
# ============================================================================ #
# File   : strExtract.bash                                                     #
# Project: BibleVox                                                            #
# Date   : 2017.02.25                                                          #
# Author : MEAdams                                                             #
# Purpose: Locate all occurrences of a text string found within a specified    #
#        : bible text file. Return the scripture references where the text     #
#        : string was found. This script is inteded for locating whole         #
#        : words such as proper names.                                         #
#        :                                                                     #
# -------:-------------------------------------------------------------------- #
# Notes &: 1. This script returns scripture references where the text is found #
# Assumes:    which are not sufficient for counting to obtain a sum total of   #
#        :    all occurances because the text might appear more than once per  #
#        :    reference (very common). Therefore, a subsequent search would    #
#        :    be necessary to find the number of occurrences per scripture     #
#        :    reference.                                                       #
#        :                                                                     #
# -------:-------------------------------------------------------------------- #
# To Do  : 1. Add an option for also returning the verse text.                 #
#        :                                                                     #
# =============================================================================#
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

# Verify two arguments were provided
if [ -z "${1}" ]; then usage; fi
if [ -z "${2}" ]; then usage; fi

# Arguments
TXT="../Texts/${1}.copyrighted"
STR=$( echo "${2}" | ../ascii2utf.bash )  # See notes below

# Read text file
_try cat "${TXT}" | \

# Change ASCII dash, double dash and apostrophe codes to UTF8 codes for the
# "en dash", "em dash" and "right single quote", respectively. This has no
# effect if the UTF8 characer codes already are present.
../ascii2utf.bash | \

# Find the text string occurrences
grep -i -E "(^|[^–])\\b${STR}\\b([^–]|$)" | \

# Return scripture references for the occurrences
sed 's/^\(.*[0-9]*:[0-9]*:\).*/\1/g'
