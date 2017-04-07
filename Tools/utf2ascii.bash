#!/bin/bash
# ============================================================================ #
# File   : utf2ascii.bash                                                      #
# Project: BibleVox                                                            #
# Date   : 2016.05.01                                                          #
# Author : MEAdams                                                             #
# Purpose: SED pipe to convert some UTF8 characters known to cause problems    #
#        : in Festival to 8-bit ASCII                                          #
# ============================================================================ #
# Pipe to apostrophe encoding filter
# 0x2E 0x80 0x99 --> 0x27
sed s/"’"/"'"/g | \

# Pipe to hyphen encoding filter
# 0x2E 0x80 0x93 --> 0x2D
sed s/"–"/"-"/g | \

# Pipe to wide hyphen encoding filter
# 0x2E 0x80 0x94 --> 0x2D 0x2D
sed s/"—"/"--"/g
