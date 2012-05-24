autossh-tunnel
==============
Setup and keep alive ssh tunnels to remote sites using autossh, screen, cron.


Requirements
------------
- autossh
- screen
- cron


How it works
------------
1. Sites to tunnel to are configured in `~/.ssh/config`:
   `Host` declarations that start with 'autossh-' in the name are 
   detected as candidates for tunnel sites. Example:

        Host autossh-HOSTNAME
        Hostname HOSTNAME
        User USER
        RemoteForward 8022 localhost:22
        IdentityFile ~/.ssh/autossh-id_rsa

2. `ssh-keygen.sh`: helper script to generate an SSH key without passphrase.
   Note: for added security, the public key is configured with the
   following options:

        command="/bin/false",no-agent-forwarding,no-X11-forwarding,no-pty

3. `ssh-copy-id.sh`: helper script to install SSH key in
   `~/.ssh/authorized_keys` on each of the detected tunnel sites

4. `setup.sh`:

   Print the details of the detected setup:
   - SSH key that will be used with `autossh`
   - Detected tunnel sites in `~/.ssh/config`
   - Confirmed tunnel sites (accepting the SSH key)

   Print the steps to complete the configuration.

   Print tips how to test the configuration.

5. `autossh.sh`: run `autossh` for each detected site in an independent
   `screen` session, unless already running

6. `crontab.sh`: helper script to add or remove a cron job to
   periodically run `autossh.sh`


How to install
--------------
Simply run `./setup.sh` and follow the steps. This script does not
do anything. It only tells you the configuration it detected and
gives you the steps you need to follow to complete the configuration.


How to uninstall
----------------
- `./crontab.sh --remove` to remove the cron job
- `./stop.sh` to stop any running `autossh` and `screen` instances
- Login to each tunnel site and manually remove the script's SSH key
  from `~/.ssh/authorized_keys`


