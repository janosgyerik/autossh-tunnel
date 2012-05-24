#!/bin/sh -e
# 
# File: confirmed-tunnel-sites.sh
# Purpose: print detected tunnel sites that have been confirmed to work
#

cd $(dirname "$0")
. ./common.sh

for tunnelsite in $(./detect-tunnel-sites.sh); do
    test -f $confirmed_dir/$tunnelsite || continue
    echo $tunnelsite
done

# eof
