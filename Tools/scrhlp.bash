#!/bin/bash
# ============================================================================ #
# File   : scrhlp.bash                                                         #
# Project: BibleVox                                                            #
# Date   : 2016.05.01                                                          #
# Author : MEAdams                                                             #
# Purpose: Misc. Bash helper functions and utilities                           #
# Usage  : source /dir/path/scrhlp.bash                                        #
# ============================================================================ #
# printf mock echo format string
_eko="%b\n"

# ANSI Escape Sequence to clear console screen buffer
_clr='printf \033c'

# Strong Kung Fu (i.e. absolutely indispensable Bash scripting support):
# Error handling (the Three-Fingered Claw technique - author unknown)
cry() { echo "$0: $*" >&2; }         # send cmd name and args to stderr
die() { cry "$*"; exit 111; }        # cry and exit with failed status
_try() { "$@" || die "cannot $*"; }  # $@ contains cmd name and args, so
                                     # it causes cmd to run as called and
                                     # a non-zero return code calls die

# remove command from shell job list, redirect streams (dflt /dev/null)
function _detachcmd () {
    (   
        if test -t 1; then  # stdout config
            exec 1>/dev/null
        fi

        if test -t 2; then  # stderr config
            exec 2>/dev/null
        fi

        exec "$@" &  # exec str args in the bkgrd
    )
}

# sane single character input (i.e. filter out ascii escape sequences)
function _readchar () {
    # character is returned in $1
    local char=""; local _char=$1
    IFS= read -r -s -n 1 char

    case $char in
        $'\033' )  # ESC
            IFS= read -r -s -n 1 -s -t 0.01
            if [ $? -ne 0 ]  # if timeout, then read buffer was empty
            then
                # therefore, return the ESC character
                char=$char
            else
                # else, read buffer contains an ESC sequence - discard
                while read -r -s -t 0; do read -r -s -n 1; done
                char=0  # return a null character
            fi
            ;;
        * )
            char=$char
            ;;
    esac

    if [[ "$_char" ]]
    then
	eval $_char="'${char}'"  # works fine with characters
    else
        echo "$char"             # works fine with characters
    fi
    return 0
}

# sane single character input (i.e. filter out ascii escape sequences)
# this returns the ascii decimal code rather than the ascii character
function _readcode () {
    # character is returned in $1
    local char=""; local code=""; local _code=$1
    IFS= read -r -s -n 1 char

    case $char in
        $'\033' )  # ESC
            IFS= read -r -s -n 1 -s -t 0.01
            if [ $? -ne 0 ]  # if timeout, then read buffer was empty
            then
                # therefore, return the ascii ESC code
                code=27
            else
                # else, read buffer contains an ESC sequence - discard
                while read -r -s -t 0; do read -r -s -n 1; done
                code=0  # return a null code
            fi
            ;;
        * )
            # else, return the ascii decimal code of the character
            # (because otherwise you can't return the single quote key)
            printf -v code "%d" "'${char}"  # get ascii decimal code
            ;;
    esac

    if [[ "$_code" ]]
    then
	eval $_code="'${code}'"  # this doesn't work with codes??
    else
        echo "$code"             # this works with codes
    fi
    return 0
}

# get ism index partition location
function _ismpart () {
    local _idx=$1
    echo `expr $_idx : '^[0-9]*[:,-]'`
}

# get ism index number
function _ismLpart () {
    local _idx=$1
    echo `expr $_idx : '^\([0-9]*\)'`
}

# get ism index text
function _ismRpart () {
    local _idx=$1
    echo ${_idx:$(_ismpart $_idx)}
}
