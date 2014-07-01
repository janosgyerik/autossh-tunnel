autossh-tunnel
==============
Setup and keep alive ssh tunnels to remote sites using autossh, screen.


Requirements
------------
- autossh
- screen


How it works
------------
Configure the sites you want to tunnel to in `~/.ssh/config`:
`Host` declarations prefixed with 'autossh-' are 
detected as *candidates* for tunnel sites, for example:

    Host autossh-HOSTNAME
    Hostname HOSTNAME
    User USER
    RemoteForward 8022 localhost:22
    IdentityFile ~/.ssh/autossh-id_rsa

`ssh-keygen.sh`:
this is a helper script to generate an SSH key with empty passphrase.
Beware, normally this is considered a *dangerous* thing to do.
We sacrifice some security in favor of convenience,
so that you can easily start ssh tunnels from cron,
without having to reenter a passphrase after every reboot.

To make this less insecure,
the public key will be configured on the remote site with these very restrictive ssh key authorization options:

    command="/bin/false",no-agent-forwarding,no-X11-forwarding,no-pty

`ssh-copy-id.sh`:
this is a helper script to install the dedicated SSH key in `~/.ssh/authorized_keys` on each of the detected tunnel sites.

`setup.sh`:
helper script to walk you through the setup steps or print the details of the detected setup:

- Print the details of the detected setup, such as:

   - SSH key that will be used with `autossh`
   - Detected tunnel sites in `~/.ssh/config`
   - Confirmed tunnel sites (accepting the SSH key)

- Print the steps to complete the configuration.

- Print tips how to test the configuration.

`autossh.sh`:
wrapper script to run `autossh` for each detected site in an independent `screen` session.
It reuses an existing session or else it creates a new one.

`crontab.sh`:
helper script to add a line like this in `crontab` to periodically run `autossh.sh`:

    0 * * * * AUTOSSH_PORT=0 $PWD/autossh.sh


How to install
--------------
Simply run `./setup.sh` and follow the steps. This script does not
do anything. It only tells you the configuration it detected and
gives you the steps you need to follow to complete the configuration.


How to uninstall
----------------
- Remove any `cron` jobs running `autossh.sh`
- `./stop.sh` to stop any running `autossh` and `screen` instances
- Login to each tunnel site and manually remove the script's SSH key
  from `~/.ssh/authorized_keys`


