#!/bin/bash
# ============================================================================ #
# File   : verseperline.bash                                                   #
# Project: BibleVox                                                            #
# Date   : 2017.02.27                                                          #
# Author : MEAdams                                                             #
# Purpose: Format Bible text as only one verse reference with text per line.   #
# ============================================================================ #
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
sed '/^$/d'
