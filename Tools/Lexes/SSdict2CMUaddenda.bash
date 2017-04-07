#!/bin/bash
# ============================================================================ #
# File   : SSdict2CMUaddenda.bash                                              #
# Project: BibleVox                                                            #
# Date   : 2016.09.03                                                          #
# Author : MEAdams                                                             #
# Purpose: Translate the SndSpell dictionary into a CMU Scheme code addenda    #
# ============================================================================ #
# Script name
scr=$(basename "$0")

# Load utility helper scripts
source ../scrhlp.bash > /dev/null 2>&1
if [ $? -gt 0 ]; then echo "ABORT: ${scr} can't find scrhlp.bash"; exit 1; fi

# User help
usage() { printf "${_eko}" "
Usage: ./${scr} prjName
Where: prjName = SndSpell dictionary project name (e.g. BibleVox) \n" \
1>&2; exit 1; }

if [ -z "${1}" ]; then usage; fi

# Project name argument
prj="${1}"

# Obligatory BibleVox copyright license text
_try cat ../../LICENSE | awk '{ print $0 }' | \
awk '{ print "; " $0}' > "./${prj}Lex.scm"

# Get the dictionary words with pronunciation guides
_try cat "./${prj}Dict.menu" | awk '{ print $0 }' | \

# Create CMU Festival speech engine lexicon Scheme code addenda
./SSdict2ABdict | \
awk '{ print "(lex.add.entry \n \x27" $0 " )" }' >> "./${prj}Lex.scm"
