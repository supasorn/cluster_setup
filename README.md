# cluster_setup

In your terminal, run this command on each node (This script assumes the same username / password on all nodes):
```
bash -c "$(curl -fsSL https://raw.githubusercontent.com/supasorn/cluster_setup/master/setup.sh)"
```

This script setups each node so that it can access all other nodes via ssh without password. The script does the following:
1. Add v1, v2, ... aliases to /etc/hosts. So that you can use "v1" instead of 10.0.0.1 in ssh, http, browsers.
2. Remove Hostname v1, ... in ~/.ssh/config to avoid conflicts.
3. ssh-keygen for the current machine, if id_rsa / id_rsa.pub don't already exist.
4. Remove ~/.ssh/known_hosts for a clean setup.
5. ssh-copy-id the public key of the current machine to v1-v24, and auto add hostkey.

If the scrtipt is successful, you should see
```
1 vision01
2 vision02
3 Vision03
4 vision04
5 vision05
...
```
