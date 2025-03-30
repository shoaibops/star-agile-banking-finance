resource "aws_instance" "test-server" {
  ami = "ami-0e35ddab05955cf57"
  instance_type = "t3.medium"
  key_name = "aws-key"
  vpc_security_group_ids = ["sg-06b4c17cdf01af9b0"]
  connection {
     type = "ssh"
     user = "ec2-user"
     private_key = file("./aws-key.pem")
     host = self.public_ip
     }
  provisioner "remote-exec" {
     inline = ["echo 'wait to start the instance' "]
  }
  tags = {
     Name = "test-server"
     }
  provisioner "local-exec" {
     command = "echo ${aws_instance.test-server.public_ip} > inventory"
     }
  provisioner "local-exec" {
     command = "ansible-playbook /var/lib/jenkins/workspace/bankingproject/terraform-files/ansibleplaybook.yml"
     }
  }
