#!/bin/bash
# ============================================================================ #
# File   : words2color.bash                                                    #
# Project: BibleVox                                                            #
# Date   : 2017.05.20                                                          #
# Author : MEAdams                                                             #
# Purpose: grep pipe to search for words within text and colorize them         #
# ============================================================================ #
# Read translation specific BibleVox dictionary menu file
cat ${1}accepts.diag | \

# Remove comment lines
sed -e '/^#.*/d' | \

# Morph certain ascii codes to utf8 codes to make them searchable
../ascii2utf.bash | \

# Get head word column, create grep search patterns and save
awk '{ print "(^|[^–])\\b"$1"\\b([^–]|$)" }' > ${1}keys.diag

# Read specified Bible text file
cat ../Texts/$1.copyrighted | \

# Morph certain ascii codes to utf8 codes to make them searchable
../ascii2utf.bash | \

# Facilitate highlighting a word that follows a space delimited, highlighted word 
sed -e 's/ /  /g' | \

# Highlight Bible text with all occurrences of all search patterns and save
grep --color=always -E -f ${1}keys.diag | \

# Restore single space character separated words, display progress and save results
# Note that highlighted words retain double space characters
sed -e 's/  / /g' | tee /dev/tty > ${1}color.copyrighted
