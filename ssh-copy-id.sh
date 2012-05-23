#!/bin/sh
# 
# File: ssh-copy-id.sh
# Purpose: install SSH key in `~/.ssh/authorized_keys` detected tunnel sites
#

cd $(dirname "$0")
. ./common.sh

test "$1" && tunnelsites="$@" || tunnelsites=$(detect_tunnelsites)

for tunnelsite in $tunnelsites; do
    readyfile=$ready_dir/$tunnelsite
    info testing access to tunnel site $tunnelsite with ssh key
    SSH_AGENT_PID= SSH_AUTH_SOCK= ssh -i $ssh_key_file -o BatchMode=yes $tunnelsite date
    exitcode=$?
    if test $exitcode = 0; then
        warn 'It seems there is an active ControlMaster.'
        warn 'In this case it is impossible to validate the custom ssh key'
        warn 'perfectly, therefore skipping this tunnel site now.'
        warn 'Exit the ssh session that started ControlMaster'
        warn 'and run this script again.'
        continue
    elif test $exitcode = 1; then
        info 'Exit code was 1, most probably because the key is authorized'
        info 'with the forced command /bin/false as expected.'
        info marking tunnel site ready
        > $readyfile
    else
        info trying to add ssh key to remote authorized_keys file
        info 'you may be prompted for your remote password'
        ssh $tunnelsite 'mkdir -p .ssh; cat >> .ssh/authorized_keys; chmod -R go-rwx .ssh' < $ssh_key_file.pub
        if test $? = 0; then
            info 'public key was successfully installed, checking access again'
            SSH_AGENT_PID= SSH_AUTH_SOCK= ssh -i $ssh_key_file -o BatchMode=yes $tunnelsite date
            if test $? = 1; then
                info marking tunnel site ready
                > $readyfile
            fi
        else
            warn could not add ssh key to authorized_keys
        fi
    fi
done

# eof
