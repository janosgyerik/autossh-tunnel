#!/bin/sh -e
# 
# File: setup.sh
# Purpose: configure autossh-tunnel project
#

cd $(dirname "$0")
. ./common.sh

require autossh
require screen

heading() {
    echo '###' $*
}

heading variables
echo ssh_key_file=$ssh_key_file
if ! test -f $ssh_key_file; then
    warn The dedicated ssh key file "($ssh_key_file)" does not exist
    warn Create it manually or run ./ssh-keygen.sh helper script
fi
echo

heading detected tunnel sites
detected_tunnel_sites=$(./detect-tunnel-sites.sh)
if test "$detected_tunnel_sites"; then
    for tunnelsite in $detected_tunnel_sites; do
        echo $tunnelsite
    done
else
    warn 'Could not detect tunnel site configurations in ~/.ssh/config'
    warn You can configure a tunnel site like this:
    cat<<EOF
Host autossh-HOSTNAME
Hostname HOSTNAME
User USERNAME
RemoteForward 8022 localhost:22
IdentityFile $ssh_key_file
EOF
fi
echo

confirmed_tunnel_sites=$(./confirmed-tunnel-sites.sh)
if test "$confirmed_tunnel_sites"; then
    heading confirmed tunnel sites
    for tunnelsite in $confirmed_tunnel_sites; do
        echo $tunnelsite
    done
    if test "$confirmed_tunnel_sites" != "$detected_tunnel_sites"; then
        warn 'Access to some detected tunnel sites has not been confirmed yet.'
        warn 'Run ./ssh-copy-id.sh to fix that.'
    fi
    echo

    heading 'Example to test that a tunnel site is working'
    for tunnelsite in $confirmed_tunnel_sites; do
        echo "# site: $tunnelsite"
        echo "AUTOSSH_PORT=0 ./autossh.sh $tunnelsite"
        sed -ne '/^Host '$tunnelsite'$/,/^$/p' ~/.ssh/config | awk '/^User / { user = $2 } /^Hostname / { host = $2 } /^RemoteForward / { port = $2 } END { print "ssh " user "@" host; print "ssh -p " port " localhost date" }'
        echo
    done

    echo '# To stop all running autossh and screen sessions, run: ./stop.sh'
else
    warn 'No tunnel site has been confirmed as working.'
    warn 'Review your tunnel site configurations in ~/.ssh/config'
    warn 'and run ./ssh-copy-id.sh'
    warn 'This script will do several things:'
    warn '1. Authorize the custom ssh key on the tunnel site'
    warn '2. Confirm the tunnel site is accessible via the key'
    warn '3. Mark the tunnel site as "confirmed"'
fi
