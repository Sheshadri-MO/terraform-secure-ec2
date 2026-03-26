provider "aws" {
  region = "eu-north-1"
}

resource "aws_instance" "web" {
  count         = 2
  ami           = "ami-0aaa636894689fa47"
  instance_type = "t3.micro"
  key_name      = "nac"

 user_data = <<-EOF
              #!/bin/bash

              # Create devops user
              useradd -m -s /bin/bash devops

              # Wait for SSH keys
              sleep 10

              # Copy keys from ec2-user
              mkdir -p /home/devops/.ssh
              cp /home/ec2-user/.ssh/authorized_keys /home/devops/.ssh/
              chown -R devops:devops /home/devops/.ssh
              chmod 700 /home/devops/.ssh
              chmod 600 /home/devops/.ssh/authorized_keys

              # 🔥 REMOVE sudo from ec2-user
              sed -i '/ec2-user/d' /etc/sudoers

              # 🔥 LOCK ec2-user (optional but recommended)
              passwd -l ec2-user

              # Disable root login
              sed -i 's/^#PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
              sed -i 's/^PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config

              # Disable password auth
              sed -i 's/^#PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
              sed -i 's/^PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config

              systemctl restart ssh || systemctl restart sshd
              EOF

  tags = {
    Name = "web-node-${count.index + 1}"
  }
}