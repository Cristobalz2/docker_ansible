provider "aws" {
    region = var.region
}

resource "aws_instance" "host1" {
    ami = var.amiID
    instance_type = var.type
    associate_public_ip_address = true
    key_name = var.key 

    tags = {
        Name = "ansible_host1"
        Owner = "server1"
    }
}

resource "aws_instance" "host2" {
    ami = var.amiID
    instance_type = var.type
    associate_public_ip_address = true
    key_name = var.key 

    tags = {
        Name = "ansible_host2"
        Owner = "server1"
    }
}

resource "aws_instance" "master1" {
    ami = var.amiID
    instance_type = var.type
    # subnet_id = "subnet-62606418"
    associate_public_ip_address = true
    key_name = var.key 
    provisioner "local-exec" {
      command = "./files/replace.sh $HOST1 $HOST2"

      environment = {
        HOST1 = aws_instance.host1.public_ip
        HOST2 = aws_instance.host2.public_ip
    }
  }
    provisioner "file" {
      source      = "ansible-docker"
      destination = "/home/ec2-user/ansible-docker"  
    }
    provisioner "file" {
      source      = "~/.ssh/remote-key"
      destination = "/home/ec2-user/ansible-docker/remote-key"  
    }

    provisioner "remote-exec" {
      inline = [
        "mv /home/ec2-user/ansible-docker/remote-key",
        "chmod +x /home/ec2-user/ansible-docker/docker_ansible.sh",
        "/home/ec2-user/ansible-docker/docker_ansible.sh"
      ]
    }
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("~/.ssh/remote-key")
      host        = aws_instance.master1.public_ip
    }
#    user_data = file("docker_ansible.sh")
#     root_block_device {
#         volume_size = "40"
#         volume_type = "standard"
#   }
    tags = {
        Name = "server_ansible"
        Owner = "server"
    }
    depends_on = [aws_instance.host1, aws_instance.host2]
}

output "ansible_master" {
  value = aws_instance.master1.public_ip
}
output "ansible_host1" {
  value = aws_instance.host1.public_ip
}
output "ansible_host2" {
  value = aws_instance.host2.public_ip
}