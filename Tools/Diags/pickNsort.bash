#!/bin/bash
# ============================================================================ #
# File   : pickNsort.bash                                                      #
# Project: BibleVox                                                            #
# Date   : 2017.06.23                                                          #
# Author : MEAdams                                                             #
# Purpose: Extract entries from the named BibleVox dictionary menu file that   #
#        : possess the specified parts of speech (POS) and/or general word     #
#        : category (GWC) tags. Sort the extracted entries.                    #
#        :                                                                     #
# -------:-------------------------------------------------------------------- #
# Notes &:  1. Note: GWC wild card: .*                                         #
#        :  2. Note: POS wild character: ?                                     #
#        :  3. Example inclusive GWC: -c person                                #
#        :  4. Example exclusive GWC: -c ^person$                              #
#        :  5. Example inclusive, sequential GWC: -c person,place              #
#        :  6. Example exclusive, sequential GWC: -c ^person,place$            #
#        :  7. Example inclusive, separated GWC: -c person.*ethnic             #
#        :  8. Example exclusive, separated GWC: -c ^person.*ethnic$           #
#        :  9. Example inclusive ORed GWC: -c p[el] (i.e. person or place)     #
#        :  9. Example exclusive POS: -s pns (i.e. only pns)                   #
#        : 10. Example inclusive POS: -s pn? (i.e. pns, pnp)                   #
#        : 11: Example incluseve POS: -s ?n? (i.e. cns,cnp,pns,pnp)            #
#        : 12: Much more possible. Play with it!                               #
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

# Load data files
posTags=$( _try cat ./posTags.data )
gwcTags=$( _try cat ./gwcTags.data )

# Create message strings
align=$( printf "%0.s " $( seq 1 22 ) )
posMsg=$( printf "%s, " ${posTags} | fold -s -w 60 | sed -e "2,\$s/^/$align/" )
gwcMsg=$( printf "%s, " ${gwcTags} | fold -s -w 60 | sed -e "2,\$s/^/$align/" )

# Specify usage message
usage()
{ printf "${_eko}" "
Usage: ./${scr} -m mnuFbn [-s posTag] [-c gwcTag]
Where: mnuFbn = the base name of dictionary menu file (e.g. ESV, KJV)
       posTag = parts-of-speech search tag
                (i.e. ${posMsg})
       gwcTag = general word category search tag
                (i.e. ${gwcMsg}) \n
Note: One or both of \"posTag\" and \"gwcTag\" must be specified. \n"
1>&2; exit 1; }

# process command line arguments
mnu="";pos="";gwc=""
while getopts ":m:s:c:" opt; do
    case "${opt}" in
        m)
            mnu="${OPTARG}"
            ;;
	s)
	    pos="${OPTARG}"
	    ;;
	c)
	    gwc="${OPTARG}"
	    ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

# Verify the required number of arguments were provide
if [ -z "${mnu}" ]; then usage; fi
if [ -z "${pos}" ] && [ -z "${gwc}" ]; then usage; fi

# When only one provided default other as wild card
if [ -z "${pos}" ]; then pos=".*"; fi
if [ -z "${gwc}" ]; then gwc=".*"; fi

# Perform the requested search
_try awk '$2 ~ /'"${pos}"'/{ print $0 }' "${mnu}" | \
awk '$5 ~ /'"${gwc}"'/{ print $0 }' | sort -k 1
