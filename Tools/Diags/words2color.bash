#!/bin/bash
# ============================================================================ #
# File   : words2color.bash                                                    #
# Project: BibleVox                                                            #
# Date   : 2017.05.20                                                          #
# Author : MEAdams                                                             #
# Purpose: grep pipe to search for words within text and colorize them         #
# -------:-------------------------------------------------------------------- #
# Notes &: 1. In addition to single words, this utility will also process      #
# Assumes:    multi-word strings (e.g. "Holy Spirit" and "Jesus Christ"). The  #
#        :    BibleVox dictionary menu file, the words to be searched for,     #
#        :    employs underscore characters (i.e. "_") as place holders which  #
#        :    this utility will process as space characters within multi-word  #
#        :    entries.
# ============================================================================ #
# Script name
scr=$(basename "$0")

# Load utility helper scripts
source ../scrhlp.bash > /dev/null 2>&1
if [ $? -gt 0 ]; then echo "ABORT: ${scr} can't find scrhlp.bash"; exit 1; fi

# User help
usage() { printf "${_eko}" "
Usage: ./${scr} txtFile
Where: txtFile = base name of text file to search (e.g. ESV, KJV)
       wrdFile = full name of word regexps source file \n" \
1>&2; exit 1; }

# Verify arguments were provided
if [ -z "${1}" ]; then usage; fi

# Arguments
BTXT="../Texts/${1}.copyrighted"
DICT="${2}"
PARS="${DICT#*_}";PARS="${PARS%.*}"
REGX="${DICT%.*}_regexps.diag"
CTXT="${1}_${PARS}_colored.copyrighted"

# Read the translation specific BibleVox dictionary menu file and remove all
# comment lines.
_try cat ${DICT} | sed -e '/^#.*/d' | \

# Extract the head word column and create their grep search patterns. Note
# that the search pattern delimiter is the grep word boundary code excluding
# the ASCII hyphen character, which appears in many Bible text proper names.
# This pattern prevents substrings from matching hyphenated name fragments.
awk '{ print "((^|[^-])\\b"$1"\\b([^-]|$))|$" }' | \

# Change ASCII dash, double dash and apostrophe codes to UTF8 codes for the
# "en dash", "em dash" and "right single quote", respectively.
../ascii2utf.bash | \

# Change all BibleVox multi-word placeholder underscore characters (i.e. "_")
# into double space characters and save this final product. Double spaces are
# needed rather than single spaces because of the Bible text color code process
# to follow.
sed -e 's/_/  /g' > ${REGX}

# Read the specified Bible text file. Note that the format of this file must
# be single verse per line.
_try cat ${BTXT} | \

# Change ASCII dash, double dash and apostrophe codes to UTF8 codes for the
# "en dash", "em dash" and "right single quote", respectively. This has no
# effect if the UTF8 characer codes already are present.
../ascii2utf.bash | \

# The ANSI ESC color codes to be inserted will cause problems when grepping
# through space delimited words (see the reason explained in the solution).
# However, one solution, there possibly may be others, is to double space
# between words. This insures that a space character will appear after ANSI
# ESC color codes inserted between space delimited words, which facilitates
# proper grepping. Note that "space delimited words" means words without
# any interceding punctuation mark.
sed -e 's/ /  /g' | \

# Highlight the entire Bible text with all occurrences of all search patterns.
grep --color=always -E -f ${REGX} | \

# Restore single space delimited word boundaries. Display and save the results.
# Note that highlighted space delimited words will retain double spacing
# because the original space precedes the ANSI ESC color code and the inserted
# space follows the ANSI ESC color code (i.e. grep and sed see single spaced
# entities). There seems to be no way around this. Highlighted multi-word space
# delimited strings will return to single spaces between words because no ANSI
# ESC color code had been inserted between the words. However, they will retain
# double spacing before and after the highlighted multi-word strings because
# color codes had been inserted there.
sed -e 's/  / /g' | tee /dev/tty > ${CTXT}
