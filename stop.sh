#!/bin/sh -e
# 
# File: stop.sh
# Purpose: stop autossh for tunnel sites
#

cd $(dirname "$0")
. ./common.sh

test "$1" && tunnelsites="$@" || tunnelsites=$(./confirmed-tunnel-sites.sh)

for tunnelsite in $tunnelsites; do
    info stopping $tunnelsite ...
    screen -S $tunnelsite -p 0 -X stuff 
done
