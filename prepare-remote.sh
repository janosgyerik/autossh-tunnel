#!/bin/sh
# 
# File: prepare-remote.sh
# Purpose: prepare remote location for allowing a tunnel forwarding account
#

cd $(dirname $0)
. ./common.sh

test "$1" && tunnelsites="$@" || tunnelsites=$(detect_tunnelsites)

for tunnelsite in $tunnelsites; do
    info testing access to tunnel site $tunnelsite with ssh key
    SSH_AGENT_PID= SSH_AUTH_SOCK= ssh -o BatchMode=yes $tunnelsite date
    if ! test $? = 0 -o $? = 1; then
	warn could not login to tunnel site $tunnelsite with ssh key
	info trying to add ssh key to remote authorized_keys file
	info you will be prompted for your remote password
	sed -e "s/^/command=\"\/bin\/false\",no-agent-forwarding,no-X11-forwarding,no-pty /" $ssh_key_file.pub > authorized_keys
	ssh $tunnelsite 'mkdir -p .ssh; cat >> .ssh/authorized_keys; chmod -R go-rwx .ssh' < authorized_keys
	if ! test $? = 0 -o $? = 1; then
	    warn could not add ssh key to authorized_keys, skipping $tunnelsite
	    continue
	fi
    fi
    info marking tunnel site ready
    readyfile=$ready_dir/$tunnelsite
    > $readyfile
    echo
done

# eof
