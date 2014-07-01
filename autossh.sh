#!/bin/sh -e
# 
# File: autossh.sh
# Purpose: run autossh for each tunnel site, if not already running
#

cd $(dirname "$0")
. ./common.sh

test "$1" && tunnelsites="$@" || tunnelsites=$(./confirmed-tunnel-sites.sh)

# for Mac OS X, otherwise it just doesn't work...
export AUTOSSH_PORT=0

match_session() {
    screen -ls | grep -F .$1
}

for tunnelsite in $tunnelsites; do
    if ! is_confirmed_tunnelsite $tunnelsite; then
        warn tunnelsite: $tunnelsite is not confirmed skipping.
        continue
    fi

    # stop running session, unless it matches "Attached" or "Detached"
    if ! match_session $tunnelsite | awk '$0 !~ /tached/ { exit 1 }'; then
        ./stop.sh $tunnelsite
    fi

    if ! match_session $tunnelsite >/dev/null; then
        echo \* starting autossh ...
        screen -d -m -S $tunnelsite autossh -N $tunnelsite
        echo \* done.
    fi
done
