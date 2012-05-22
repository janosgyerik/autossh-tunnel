#!/bin/sh
#
# File: common.sh
# Purpose: common functions and configuration values
# Note: at the bottom, we source ./local.sh if exists, useful for overrides
#

hostname=$(hostname)

keyfile=~/.ssh/autossh-id_rsa

ready_dir=ready
mkdir -p $ready_dir

is_ready_tunnelsite() {
    readyfile=$ready_dir/$1
    test -f $readyfile && return 0 || return 1
}

detect_tunnelsites() {
    grep '^Host autossh-.*' ~/.ssh/config 2>/dev/null | cut -f2 -d' '
}

info() {
    echo '[info]' $@
}
checking() {
    echo '[check]' $@
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

test -f ./local.sh && . ./local.sh

# eof
