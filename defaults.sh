#!/bin/sh -e
#
# File: defaults.sh
# Purpose: default variable settings
# Note: feel free to override any of these in ./local.sh
#

# path to the ssh private key used when connecting to tunnel sites
ssh_key_file=~/.ssh/autossh-id_rsa

# comment used in the ssh public key when generating it with ./ssh-keygen.sh
ssh_key_comment=autossh-$(hostname)

# eof
