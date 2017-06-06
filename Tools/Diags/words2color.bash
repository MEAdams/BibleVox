#!/bin/bash
# ============================================================================ #
# File   : words2color.bash                                                    #
# Project: BibleVox                                                            #
# Date   : 2017.05.20                                                          #
# Author : MEAdams                                                             #
# Purpose: grep pipe to search for words within text and colorize them         #
# ============================================================================ #
# Script name
scr=$(basename "$0")

# Load utility helper scripts
source ../scrhlp.bash > /dev/null 2>&1
if [ $? -gt 0 ]; then echo "ABORT: ${scr} can't find scrhlp.bash"; exit 1; fi

# User help
usage() { printf "${_eko}" "
Usage: ./${scr} txtFile \n
Where: txtFile = base name of text file to search (e.g. ESV, KJV) \n" \
1>&2; exit 1; }

# Verify arguments were provided
if [ -z "${1}" ]; then usage; fi

# Arguments
BTXT="../Texts/${1}.copyrighted"
CTXT="${1}colored.copyrighted"
DICT="${1}accepts.diag"
REGX="${1}regexps.diag"

# Read the translation specific BibleVox dictionary menu file.
_try cat ${DICT} | \

# Remove all comment lines.
sed -e '/^#.*/d' | \

# Change ASCII dash, double dash and apostrophe codes to UTF8 codes for the
# "en dash", "em dash" and "right single quote", respectively. This has no
# effect if the UTF8 characer codes already are present.
../ascii2utf.bash | \

# Get the head word column and create and save grep search patterns. Note
# that the search pattern delimiter is the grep word boundary code excluding
# the "en dash" character, which appears in many Bible text proper names.
# This prevents substrings from matching hyphenated name fragments.
awk '{ print "(^|[^–])\\b"$1"\\b([^–]|$)" }' > ${REGX}

# Read the specified Bible text file.
_try cat ${BTXT} | \

# Change ASCII dash, double dash and apostrophe codes to UTF8 codes for the
# "en dash", "em dash" and "right single quote", respectively. This has no
# effect if the UTF8 characer codes already are present.
../ascii2utf.bash | \

# The ANSI ESC color codes to be inserted will cause problems when grepping
# through space delimited words. The reason is hard to explain. However, one
# solution, there possibly may be others, is to double space between words.
# This insures that a space character will appear after ANSI ESC color codes
# inserted between space delimited words, which facilitates proper grepping.
# Note that by "space delimited words" is meant words without any interceding
# punctuation mark.
sed -e 's/ /  /g' | \

# Highlight the entire Bible text with all occurrences of all search patterns.
grep --color=always -E -f ${REGX} | \

# Restore single space delimited word boundaries. Display and save the results.
# Note that highlighted space delimited words will retain double spacing
# because the original space precedes the ANSI ESC color code and the inserted
# space follows the ANSI ESC color code (i.e. grep and sed see single spaced
# entities).
sed -e 's/  / /g' | tee /dev/tty > ${CTXT}
