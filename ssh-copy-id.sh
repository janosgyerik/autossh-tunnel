#!/bin/sh -e
# 
# File: ssh-copy-id.sh
# Purpose: install SSH key in `~/.ssh/authorized_keys` detected tunnel sites
#

cd $(dirname "$0")
. ./common.sh

test "$1" && tunnelsites="$@" || tunnelsites=$(./detect-tunnel-sites.sh)

check_access_and_set_exitcode() {
    info testing access to tunnel site $tunnelsite with ssh key
    set +e
    SSH_AGENT_PID= SSH_AUTH_SOCK= ssh -i $ssh_key_file -o BatchMode=yes $tunnelsite date
    exitcode=$?
    set -e
}

ssh_copy_id() {
    info trying to add ssh key to remote authorized_keys file
    info 'you may be prompted for your remote password'
    ssh $tunnelsite 'mkdir -p .ssh; cat >> .ssh/authorized_keys; chmod -R go-rwx .ssh' < $ssh_key_file.pub
}

for tunnelsite in $tunnelsites; do
    recheck=
    confirmed_access=
    check_access_and_set_exitcode
    if test $exitcode = 0; then
        warn 'It seems there is an active ControlMaster.'
        warn 'In this case it is impossible to validate the custom ssh key'
        warn 'perfectly, but trying best effort.'
        if ssh $tunnelsite grep "^command.*$ssh_key_comment" .ssh/authorized_keys >/dev/null; then
            info 'Custom ssh key is in authorized_keys, so probably it works.'
            confirmed_access=1
        else
            info 'Custom ssh is not in authorized_keys.'
            ssh_copy_id && recheck=1 || continue
        fi
    elif test $exitcode = 1; then
        info 'Exit code was 1, most probably because the key is authorized'
        info 'with the forced command /bin/false as expected.'
        confirmed_access=1
    else
        ssh_copy_id && recheck=1 || continue
    fi
    if test "$recheck"; then
        info 'checking access again'
        check_access_and_set_exitcode
        test $exitcode = 0 -o $exitcode = 1 && confirmed_access=1
    fi
    if test "$confirmed_access"; then
        info marking tunnel site confirmed
        > $confirmed_dir/$tunnelsite
    fi
done
