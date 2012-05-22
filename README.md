autossh-tunnel
--------------
Setup and keep alive ssh tunnels to remote sites using autossh, screen, cron.


Overview
--------
1. Create a key `~/.ssh/autossh-id_rsa.pub`, with hostname in comment, and with
    empty passphrase.

2. Add this public key to authorized_keys at remote site, with restrictions:

    command="/bin/false",no-agent-forwarding,no-X11-forwarding,no-pty,no-user-rc,from="$hostname"

3. Update my-autossh.sh script to make sure the current configuration site
    uses unique port number for forwarded ports and autossh management port.

4. Create a Host entry in ~/.ssh/config for the remote site, with port 
    forwarding definitions. Make sure port numbers are consistent with
    settings in (3) above.

    Host autossh-rhostname
    Hostname rhostname
    User ruser
    RemoteForward 8022 localhost:22
    IdentityFile ~/.ssh/autossh-id_rsa

5. Configure cron to periodically check whether the tunnel is up and restart
    it when needed.


Installation
------------
Simply run ./setup.sh to get started.
The script prints a list of remaining steps. 

If the key is compromised:

1. Login to ALL remote sites and remove public key from ~/.ssh/authorized_keys

2. Remove the key locally and re-run setup.sh

