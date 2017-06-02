#!/bin/bash
# ============================================================================ #
# File   : ascii2utf.bash                                                      #
# Project: BibleVox                                                            #
# Date   : 2016.05.01                                                          #
# Author : MEAdams                                                             #
# Purpose: SED pipe to convert some 8-bit ASCII characters to UTF-8 codes      #
#        : that are known to cause problems in Festival.                       #
# ============================================================================ #
# Pipe to apostrophe encoding filter
# 0x27 --> 0x2E 0x80 0x99
sed s/"'"/"’"/g | \

# Pipe to wide hyphen encoding filter
# 0x2D 0x2D --> 0x2E 0x80 0x94
sed s/"--"/"—"/g | \

# Pipe to hyphen encoding filter
# 0x2D --> 0x2E 0x80 0x93
sed s/"-"/"–"/g
