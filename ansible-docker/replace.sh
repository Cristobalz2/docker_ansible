sed -i -e "/[[server1]]/a$1 ansible_user=ec2-user ansible_private_key_file=remote-key" $PWD/ansible-docker/host_file
sed -i -e "/[[server1]]/a$2 ansible_user=ec2-user ansible_private_key_file=remote-key" $PWD/ansible-docker/host_file

