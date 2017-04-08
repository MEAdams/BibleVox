#!/bin/bash
# mea-2016.07.05
# Script to install the festvox festival voices and dictionaries.
# This script must be executed sudo.
# Ubuntu 16.04 supports version Festival 2.4 natively. However,
# only the kal_diphone voice is provided. This script installs the
# high quality voices plus the rab_diphone voice from the local festival
# development director into the Ubuntu festival voices directory. The
# more up-to-date dictionary support also will be copied.

# Mind the copyright! I am using this software for personal use.

# define some directory paths
curdir=$(pwd)
scrdir=${curdir}/../Tools
srcdir=${curdir}/build/festival/lib
dstdir=/usr/share/festival

# get home grown bash script helper functions and utilities
source $scrdir/scrhlp.bash > /dev/null 2>&1

# Make sure all dirs are: chown root:root, chmod 755
# Make sure all files are: chown root:root, chmod 644

# Copy the festvox festival voices
#_try cp -pr --backup=t ${srcdir}/voices ${dstdir}
_try chown -R root:root ${dstdir}/voices
_try find ${dstdir}/voices -type d -print0 | xargs -0 chmod 755
_try find ${dstdir}/voices -type f -print0 | xargs -0 chmod 644

# Copy the festvox festival dictionaries
#_try cp -pr --backup=t ${srcdir}/dicts ${dstdir}
_try chown -R root:root ${dstdir}/dicts
_try find ${dstdir}/dicts -type d -print0 | xargs -0 chmod 755
_try find ${dstdir}/dicts -type f -print0 | xargs -0 chmod 644

cd ..
