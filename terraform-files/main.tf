resource "aws_instance" "test-server" {
  ami             = "ami-076c6dbba59aa92e6"
  instance_type   = "t3.medium"
  key_name        = "aws-key"
  vpc_security_group_ids = ["sg-0fb17682353d4a422"]

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("/var/lib/jenkins/workspace/bankingproject/terraform-files/aws-key.pem")
    host        = self.public_ip
    timeout     = "2m"
    agent       = false
  }

  provisioner "remote-exec" {
    inline = ["echo 'wait to start the instance'"]
  }

  tags = {
    Name = "test-server"
  }

  provisioner "local-exec" {
    command = "echo '[test-server]' > inventory && echo '${aws_instance.test-server.public_ip}' >> inventory"
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i inventory /var/lib/jenkins/workspace/bankingproject/terraform-files/ansibleplaybook.yml"
  }
}
