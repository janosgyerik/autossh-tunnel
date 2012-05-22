#!/bin/sh
# 
# File: autossh.sh
# Purpose: run autossh for each tunnel site, if not already running
#

cd $(dirname $0)
. ./common.sh

test "$1" && tunnelsites="$@" || tunnelsites=$(detect_tunnelsites)

for tunnelsite in $tunnelsites; do
    if ! is_ready_tunnelsite $tunnelsite; then
	warn tunnelsite: $tunnelsite is not ready. skipping.
	continue
    fi
    if ! screen -ls | grep -F .$tunnelsite >/dev/null; then
	echo \* starting autossh ...
	screen -d -m -S $tunnelsite autossh -N $tunnelsite
	echo \* done.
    fi
done

# eof
