#!/bin/bash
# ============================================================================ #
# File   : makeFlexExec.bash                                                   #
# Project: BibleVox                                                            #
# Date   : 2016.09.03                                                          #
# Author : MEAdams                                                             #
# Purpose: Convert FLEX source into C source and compile into an executable    #
# ============================================================================ #
# Script name
scr=$(basename "$0")

# load utility helper scripts
source ../scrhlp.bash > /dev/null 2>&1
if [ $? -gt 0 ]; then echo "ABORT: ${scr} can't find scrhlp.bash"; exit 1; fi

# User help
usage() { printf "${_eko}" "
Usage: ./${scr} prjName
Where: prjName = base FLEX code source file name (e.g. SSdict2ABdict) \n" \
1>&2; exit 1; }

if [ -z "${1}" ]; then usage; fi

# Project name argument
prj="${1}"

# convert FLEX code to C code
_try flex -o "./${prj}.c" "./${prj}.lex"

# compile C code into an executable program
_try cc -o "${prj}" "./${prj}.c" -lfl
