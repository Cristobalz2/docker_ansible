#!/bin/bash
sudo yum update -y
sudo amazon-linux-extras install docker -y
sudo yum install -y docker
sudo service docker start
sudo usermod -a -G docker ec2-user
sleep 5
# sudo mv /home/ec2-user/remote-key /home/ec2-user/files/remote-key
sudo chmod 400 /home/ec2-user/files/remote-key
sudo docker build -t cent_ans /home/ec2-user/files/.

