[demo_instances:vars]
ansible_ssh_common_args='-o IdentityFile=.ssh/ssh_private_key -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no'
ansible_python_interpreter=/usr/bin/python3

[demo_instances:children]
demo_instance

[demo_instance]
${hostname} ansible_host=${ip_address} availability_zone=${availability_zone}

