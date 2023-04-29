#!/bin/bash
node_list=$(seq 1 23)
user=$(whoami)

read -s -p "sudo password: " password

# add v1 alias to /etc/hosts
for i in $node_list; do
  ip="10.0.0.$i"
  if ! grep -q "^$ip " /etc/hosts; then
    echo "$password" | sudo -S sh -c "echo \"$ip v${i}\" >> /etc/hosts"
  fi
  # remove host from ~/.ssh/config
  sed 's/^Host/\n&/' ~/.ssh/config | sed '/^Host '"v$i"'$/,/^$/d;/^$/d' > tmpfile && mv tmpfile ~/.ssh/config
done

# ssh-keygen if haven't done so. 
ssh-keygen -q -t rsa -N '' -f ~/.ssh/id_rsa <<<n >/dev/null 2>&1


output=()
for i in $node_list; do
  # remove old key
  ssh-keygen -f /home/$user/.ssh/known_hosts -R v$i
  # add new key
  sshpass -p "$password" ssh-copy-id $user@v$i -i /home/$user/.ssh/id_rsa.pub -oStrictHostKeyChecking=accept-new
  # ssh to auto add hostkey, and return hostname
  val=$(ssh $user@v$i -oStrictHostKeyChecking=accept-new 'hostname')
  output+=("$i $val")
done

printf '%s\n' "${output[@]}"
# if everything is successful, you should see output: 1 vision01, 2 vision02, ...
