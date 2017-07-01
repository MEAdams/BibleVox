#!/bin/bash
# ============================================================================ #
# File   : pickNsort.bash                                                      #
# Project: BibleVox                                                            #
# Date   : 2017.06.23                                                          #
# Author : MEAdams                                                             #
# Purpose: Extract entries from a BibleVox dictionary word source file that    #
#        : possess the specified parts of speech (POS) and/or general word     #
#        : category (GWC) tags. Sort the extracted entries and save them to    #
#        : a file name derived from the source file and tag options.           #
#        :                                                                     #
# -------:-------------------------------------------------------------------- #
# Notes &: 1. Note: GWC wild card: .* (i.e. regex one or more characters)      #
#        :    Note: GWC exclusion: ^ (i.e. regex begin), $ (i.e. regex end)    #
#        :    Example inclusive GWC: -c person                                 #
#        :    Example exclusive GWC: -c ^person$                               #
#        :    Example inclusive, sequential GWC: -c person,place               #
#        :    Example exclusive, sequential GWC: -c ^person,place$             #
#        :    Example inclusive, separated GWC: -c person,.*,ethnic            #
#        :    Example exclusive, separated GWC: -c ^person,.*,ethnic$          #
#        :    Example inclusive ORed GWC: -c p[el] (i.e. person or place)      #
#        :    Example exclusive POS: -s pns (i.e. only pns)                    #
#        :    Example inclusive POS: -s pn[sp] (i.e. pns, pnp)                 #
#        :    Example inclusive POS: -s [cp]n[sp] (i.e. cns,cnp,pns,pnp)       #
#        :    Other combinations are possible. Play with it!                   #
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
Usage: ./${scr} -s wrdSrc [-p posTag] [-g gwcTag]
Where: wrdSrc = name of dictionary word source file to search through
       posTag = parts-of-speech search tag
                (i.e. ${posMsg})
       gwcTag = general word category search tag
                (i.e. ${gwcMsg}) \n
Note: One or both of \"posTag\" and \"gwcTag\" must be specified. \n"
1>&2; exit 1; }

# process command line arguments
src="";pos="";gwc=""
while getopts ":s:p:g:" opt; do
    case "${opt}" in
        s)
            src="${OPTARG}"
            ;;
	p)
	    pos="${OPTARG}"
	    ;;
	g)
	    gwc="${OPTARG}"
	    ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

# Verify the required number of arguments were provide
if [ -z "${src}" ]; then usage; fi
if [ -z "${pos}" ] && [ -z "${gwc}" ]; then usage; fi

# When only one is provided, default the other to wild card
if [ -z "${pos}" ]; then pos=".*"; fi
if [ -z "${gwc}" ]; then gwc=".*"; fi

# Build legal file name fragment from POS tag
p="_"$( echo "${pos}" | \
sed -r -e 's/(\.\*)/W/g' -e 's/[\^\$]/X/g' -e 's/[,]/-/g' )

# Build legal file name fragment from GWC tag
g="_"$( echo "${gwc}" | \
sed -r -e 's/(\.\*)/W/g' -e 's/[\^\$]/X/g' -e 's/[,]/-/g' )

# Build the destination file name from the source file name and tag options
dst=$(echo $(basename "${src}") | sed -e 's/\.//g')"${p}${g}.diag"

# Perform the requested search, sort and save the results
_try awk '$2 ~ /'"${pos}"'/{ print $0 }' "${src}" | \
awk '$5 ~ /'"${gwc}"'/{ print $0 }' | sort -k 1 > "${dst}"

# Prepend the obligatory BibleVox copyright license text
_try cat ../../LICENSE | awk '{ print $0 }' | \
awk '{ print "# " $0 }' | cat - "${dst}" | sponge "${dst}"
