#!/bin/sh
# 
# File: stop.sh
# Purpose: stop autossh for tunnel sites
#

cd $(dirname "$0")
. ./common.sh

test "$1" && tunnelsites="$@" || tunnelsites=$(./confirmed-tunnel-sites.sh)

for tunnelsite in $tunnelsites; do
    pid=$(ps xa -o pid,comm,args | awk -v t=$tunnelsite '$2 == "autossh" && $0 ~ t { print $1 }')
    test "$pid" && kill $pid
done

# eof
