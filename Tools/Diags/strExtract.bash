#!/bin/bash
# ============================================================================ #
# File   : strExtract.bash                                                     #
# Project: BibleVox                                                            #
# Date   : 2017.02.25                                                          #
# Author : MEAdams                                                             #
# Purpose: Locate all occurrences of a text string found within a specified    #
#        : bible text file. Return either colorized scripture text or the      #
#        : references where the text string is found. This script finds whole  #
#        : words such as proper names rather than text fragments.              #
#        :                                                                     #
# -------:-------------------------------------------------------------------- #
# Notes &: 1.                                                                  #
#        :                                                                     #
# -------:-------------------------------------------------------------------- #
# To Do  : 1.                                                                  #
#        :                                                                     #
# =============================================================================#
# Script name
scr=$(basename "$0")

# Load utility helper scripts
source ../scrhlp.bash > /dev/null 2>&1
if [ $? -gt 0 ]; then echo "ABORT: ${scr} can't find scrhlp.bash"; exit 1; fi

# User help
usage() { printf "${_eko}" "
Usage: ./${scr} txtFile strText rtnType
Where: txtFile: base name of text file to search (e.g. ESV, KJV)
       strText: string text to search for (e.g. Peter or \"Holy Spirit\")
       rtnType: v = colorized verses (default), r = references \n
Note : strText of multiple words must be quoted (e.g. \"Simon Peter\") \n" \
1>&2; exit 1; }

# Verify two required arguments were provided
if [ -z "${1}" ]; then usage; fi
if [ -z "${2}" ]; then usage; fi

# Arguments
TXT="../Texts/${1}.copyrighted"
STR=$( echo "${2}" | ../ascii2utf.bash )  # See notes below
if [ -z "${3}" ] || [ ${3} == "v" ]; then OPT="v"; else OPT="r"; fi

# Read text file
_try cat "${TXT}" | \

# Change ASCII dash, double dash and apostrophe codes to UTF8 codes for the
# "en dash", "em dash" and "right single quote", respectively. This has no
# effect if the UTF8 characer codes already are present.
../ascii2utf.bash | \

if [[ ${OPT} == "v" ]]; then   
    # If Verse processing...
    # Find, colorize and display verses containing the text string occurrences
    grep --color=always -E "(^|[^–])\\b${STR}\\b([^–]|$)"
else
    # If Reference processing...
    # Find the text string occurrences
    grep -E "(^|[^–])\\b${STR}\\b([^–]|$)" | \

    # Extract and display scripture references for the text string occurrences
    sed 's/^\(.*[0-9]*:[0-9]*:\).*/\1/g'
fi
