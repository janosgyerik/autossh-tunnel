#!/bin/sh -e
#
# File: ssh-keygen.sh
# Purpose: create an SSH key without passphrase to use with autossh
#   in screen, with restrictive options in the public key
#

cd $(dirname "$0")
. ./common.sh

info "checking ssh key file: $ssh_key_file"
if test -f $ssh_key_file; then
    result ssh key file exists
else
    result ssh key file does NOT exist, creating now
    ssh-keygen -t rsa -C $ssh_key_comment -N '' -f $ssh_key_file
    info "adding restrictive options to public key"
    sed -e "s/^/command=\"__PATH_TO_FALSE__\",no-agent-forwarding,no-X11-forwarding,no-pty /" $ssh_key_file.pub >$ssh_key_file.pub.bak && mv $ssh_key_file.pub.bak $ssh_key_file.pub
fi

info contents of the public key: $ssh_key_file.pub
cat $ssh_key_file.pub

# eof
