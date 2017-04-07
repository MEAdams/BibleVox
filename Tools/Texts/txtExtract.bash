#!/bin/bash
# =============================================================================
# File   : txtExtract.bash
# Project: BibleVox
# Date   : 2017.02.27
# Author : MEAdams
# Purpose: Extract and reformat bible text to single verse per line always
#        : preceded by its verse reference. The extracted and formated text
#        : will be saved to a text file named "modName.txt", where "modName"
#        : is user supplied text specifying a diatheke module name. The
#        : resulting .txt file is intended to facilitate processing using
#        : standard Unix/Linux text processing utilities like SED, AWK, GREP.
#        : The resulting bible text files were necessary to generate for three
#        : reasons. First, diatheke in Ubuntu 16.04 has a bug I reported
#        : over six months ago and they seem to be too busy to implement a
#        : long time available fix that has been reported to be already
#        : available in the Debian repository. Go figure. Second, the
#        : searches I perform to identifiy which BibleVox lexicon words are
#        : employed in a particular translation can take between 3.5 to 8.5
#        : hours to run using diatheke. They take only 3.5 minutes to run
#        : using these translation text files and my utility software. Third,
#        : searches within diatheke seem unable to isolate words that begin
#        : on a new line. This is becase the word might be the trailing end
#        : of a hyphenation beginning on the preceding line. In order to
#        : isolate a word, a preceding space character is needed. This is
#        : now provided within these extracted Bible text files since all
#        : lines now begin with a verse reference.
#        :
# -------:---------------------------------------------------------------------
# Depends: 1. This code makes use of the CrossWire "diatheke" application to
#        :    extract the bible text from a CrossWire module.
#        :
# -------:---------------------------------------------------------------------
# Notes &: 1. This script makes use of an undocumented diatheke feature that
# Assumes:    was shared with me by my UK friend David F. Haslam to extract
#        :    the text from a CrossWire module.
#        : 2. Note that the text defragging process makes use of inserting
#        :    an underscore ("_") character in place of newline characters.
#        :    Heeding my warning in the "To do" section, new modules will need
#        :    to be scanned for "_" before this script is run. One has this
#        :    problem no matter what character is used to facilitate the
#        :    stripping of \n in order to defrag the text and derive the
#        :    desired verse-per-line format results. My rather restrictive SED
#        :    filters are intended to both protect from and exaggerate any
#        :    filter oversites and make problems more noticable.
#        :
# -------:---------------------------------------------------------------------
# To do  : 1. This code has been checked on ESV and KJV modules, only.
#        :    Milage may vary on other modules yet untested. That is,
#        :    validation testing needs to be performed for other modules.
#        :
# =============================================================================
# Script name
scr=$(basename "$0")

# Load utility helper scripts
source ../scrhlp.bash > /dev/null 2>&1
if [ $? -gt 0 ]; then echo "ABORT: ${scr} can't find scrhlp.bash"; exit 1; fi

# User help
usage() { printf "${_eko}" "
Usage: ./${scr} modName
Where: modName = diatheke -b module name argument (e.g. ESV, KJV) \n" \
1>&2; exit 1; }

if [ -z "${1}" ]; then usage; fi

# Module name argument
MOD="${1}"
TXT="${MOD}.copyrighted"

# Employ the undocumented diatheke query-key argument.
_try diatheke -b "${MOD}" -k "Gen-Rev" | \

# Defrag all text by replacing all "\n" with a "_".
tr '\n' '_' | \

# Reformat text to one verse per line always preceded by a verse ref.
sed 's/_*[I]*[ ]*[ a-zA-Z]* [0-9]*:[0-9]*:/\n&/g' | \

# Remove any "_" preceding verse refs that were inserted during line defrag.
sed 's/^_*\([a-Z]*\)/\1/g' | \

# Replace the embedded "_" that were inserted during line defrag with " ".
sed 's/_/ /g' | \

# Replace multiple " " with single " ".
tr -s '[:space:]' | \

# Remove all blank lines.
sed '/^$/d' | \

# Insure punctuation consists of stardard 8-bit ASCII characters, only.
# This is done to simplify word searches, which is the intended purpose of
# the resulting text file. To date, this step only insures apostrophe and
# dash characters (which can be embedded within words to be searched) are
# always encoded as 8-bit ASCII 0x27 and 0x2D, respectively.
../utf2ascii.bash > "${TXT}"

# Diatheke returns no error code if module is not installed. Instead,
# nul text is returned.
if [ ! -s "${TXT}" ]
then
    printf "${_eko}" "\nABORT: module ${MOD} is not installed"
    rm "${TXT}"
    usage
else
    # Add this warning to top of file
    sed -i '1i***************************************' "${TXT}"
    sed -i '2i***COPYRIGHTED:_NOT_FOR_DISTRIBUTION***' "${TXT}"
    sed -i '3i***************************************' "${TXT}"
fi
