#!/bin/bash
# ============================================================================ #
# File   : scanText.bash                                                       #
# Project: BibleVox                                                            #
# Date   : 2017.02.25                                                          #
# Author : MEAdams                                                             #
# Purpose: Identify occurrences of each specified text string found within     #
#        : the specified text file. Return a file containing all accepted text #
#        : strings and a file containing all rejected text strings.            #
#        :                                                                     #
# -------:-------------------------------------------------------------------- #
# To Do  : 1. Add the capability to specify a search clasifier.                #
#        :                                                                     #
# ============================================================================ #
# Script name
scr=$(basename "$0")

# Load utility helper scripts
source ../scrhlp.bash > /dev/null 2>&1
if [ $? -gt 0 ]; then echo "ABORT: ${scr} can't find scrhlp.bash"; exit 1; fi

# User help
usage() { printf "${_eko}" "
Usage: ./${scr} txtFile strFile
Where: txtFile = base name of text file to search through (e.g. ESV, KJV)
       strFile = base name of str file to search from (e.g. BibleVoxDict) \n" \
1>&2; exit 1; }

# verify two arguments were provided
if [ -z "${1}" ]; then usage; fi
if [ -z "${2}" ]; then usage; fi

# Arguments
TXT="${1}"
STR="${2}"

# build path and name of strFile
STRref="../Lexes/${STR}.menu"

TXTacc="./${TXT}accepts.diag"
TXTrej="./${TXT}rejects.diag"
TMPacc="./tmpacc"
TMPrej="./tmprej"

# delete any old temp and results files
if [[ -f "${TXTacc}" ]]; then cat /dev/null > "${TXTacc}"; fi
if [[ -f "${TXTrej}" ]]; then cat /dev/null > "${TXTrej}"; fi
if [[ -f "${TMPacc}" ]]; then cat /dev/null > "${TMPacc}"; fi
if [[ -f "${TMPrej}" ]]; then cat /dev/null > "${TMPrej}"; fi

while read -r line || [[ -n "$line" ]]; do

    # Ignore comment and blank lines.
    if [[ ! "${line}" =~ ^# ]] && [[ ! "${line}" = "" ]]
    then
        # Use only first col of $line, convert "_" chars to " " chars,
        # which is used to accommodate multi-word strings.
        string=$(echo "${line}" | awk '{ print $1 }' | tr '_' ' ')

        status=$(./strExtract.bash ${TXT} "${string}" r | ./cntExtract.bash)

        if [[ ${status} -eq 0 ]]
        then
            echo "${line}" >> "${TMPrej}"
        else
            echo "${line}" >> "${TMPacc}"
        fi
    fi
done < "${STRref}"

# if no errors occurred, format output results and delete temp files
if [[ ${?} -eq 0 ]]
then
    # Obligatory BibleVox copyright license text
    _try cat ../../LICENSE | awk '{ print $0 }' | \
    awk '{ print "# " $0 }' > "${TXTacc}"

    # Obligatory BibleVox copyright license text
    _try cat ../../LICENSE | awk '{ print $0 }' | \
    awk '{ print "# " $0 }' > "${TXTrej}"

    # Format results
    cat "${TMPacc}" | column -t >> "${TXTacc}"
    cat "${TMPrej}" | column -t >> "${TXTrej}"

    # remove temporary files
    rm "${TMPacc}"
    rm "${TMPrej}"
fi
