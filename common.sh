#!/bin/bash -e
#
# File: common.sh
# Purpose: common functions
#

. ./defaults.sh
test -f ./local.sh && . ./local.sh

confirmed_dir=./confirmed-tunnel-sites
mkdir -p $confirmed_dir

is_confirmed_tunnelsite() {
    file=$confirmed_dir/$1
    test -f $file && return 0 || return 1
}

info() {
    echo '[info]' $@
}
result() {
    echo '[result]' $@
}
warn() {
    echo '[WARN]' $@
}

require() {
    if ! type "$1" >/dev/null 2>/dev/null; then
        echo 'Fatal: program "'$1'" is either not in PATH or not installed. Exit.'
        exit 1
    fi
}

# eof
