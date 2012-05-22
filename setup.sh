#!/bin/sh -e
# 
# File: setup.sh
# Purpose: configure autossh-tunnel project
#

cd $(dirname $0)
. ./common.sh

require autossh

info "checking ssh key in $keyfile"
if test -f $keyfile; then
    result ssh key exists
else
    result ssh key does NOT exist, creating now
    ssh-keygen -t rsa -C "autossh-$hostname" -N '' -f $keyfile
fi

info detecting tunnel sites
tunnelsites=$(detect_tunnelsites)
if test "$tunnelsites"; then
    info tunnel sites found: $tunnelsites
    sed -e '/^Host autossh-/ {
        i ----
        :next
        n
        /^$/ b end
        b next
        :end
        a ----
    }
    d' < ~/.ssh/config 2>/dev/null
else
    warn "no tunnel sites found, you should configure like this in ~/.ssh/config"
    echo Host autossh-rhostname
    echo Hostname rhostname
    echo User ruser
    echo RemoteForward 8022 localhost:22
    echo IdentityFile $keyfile
fi

cat<<EOF
* Remaining steps:
*
* 1. Add tunnel host configurations to ~/.ssh/config in the format:
Host autossh-rhostname
Hostname rhostname
User ruser
RemoteForward 8022 localhost:22
IdentityFile $keyfile
*
* 2. Validate configured tunnel sites with ./prepare-remote.sh
*
* 3. Run ./crontab.sh and customize if you must.
*
* 4. Perform test:
*	./prepare-remote.sh
*	./autossh.sh autossh-rhostname
*	ssh ruser@rhostname
*	ssh -p 8022 localhost
*
EOF

# eof
