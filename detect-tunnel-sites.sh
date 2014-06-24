#!/bin/bash -e
# 
# File: detect-tunnel-sites.sh
# Purpose: detect tunnel sites configured in ~/.ssh/config
#

grep '^Host autossh-.*' ~/.ssh/config | sed -e 's/.* //'

# eof
