#!/bin/bash
# ============================================================================ #
# File    : BibleVoxConf.bash                                                  #
# Project : BibleVox                                                           #
# Date    : 2017.04.28                                                         #
# Author  : MEAdams                                                            #
# Purpose : Configure the Festival speech engine to use the BibleVox lexicon   #
# Usage   : Run: ./BibleVoxConf.bash with user privileges                      #
# --------:------------------------------------------------------------------- #
# Depends : 1. CMU Festival speech engine installed and operational            #
#         : 2. BibleVox git repository located anywhere in users environment   #
# --------:------------------------------------------------------------------- #
# Notes & : 1. Whenever the BibleVox git repository is moved to a different    #
# Assumes :    directory, this script must be re-run.                          #
# --------:------------------------------------------------------------------- #
# To Do   : 1.                                                                 #
# ============================================================================ #
# script name
scr=$(basename "$0")

# fully qualified path to BibleVox pronunciation lexicon
bvDir=$( cd "./Tools/Lexes" && pwd )
bvLex="BibleVoxLex.scm"

# load utility helper scripts
source ./Tools/scrhlp.bash > /dev/null 2>&1
if [ $? -gt 0 ]; then echo "ABORT: ${scr} can't find scrhlp.bash"; exit 1; fi

# copy Festival configuration file templet to user's home diretory
rcName=".festivalrc"
rcTemp="./${rcName}"
rcFile="${HOME}/${rcName}"
if [ -f ${rcFile} ]
then
    # be nice and make a date and time stamped backup of any existing file
    _try cp ${rcFile} ${rcFile}-$(date +"%Y%m%d_%H%M%S")
fi
_try cp ${rcTemp} ${rcFile}

# append a Scheme command for loading the BibleVox pronunciation lexicon
printf ${_eko} \
    "(load "\""${bvDir}/${bvLex}"\"")\n" >> ${rcFile}
