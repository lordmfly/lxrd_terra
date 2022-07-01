data "aws_ami" "myAmi" {
    owners = ["099720109477"]
    most_recent = true
    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-*-amd64-server-*"]
    }
}


resource "aws_default_security_group" "demo-sg"{
    vpc_id = var.vpc_id
    ingress {
    description      = "for HTTP requests"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    }
    ingress {
    description      = "for ssh"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    }
    ingress {
    description      = "for ssh"
    from_port        = 8989
    to_port          = 8989
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    }
    egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
      Name = "${var.env}-sg"
  }
}

resource "aws_key_pair" "myKey"{
    key_name = var.key
    public_key = file(var.public)
}

resource "aws_instance" "demoinstance"{
    ami = data.aws_ami.myAmi.id
    instance_type= var.instance_type
    availability_zone = var.avail_zone1
    key_name = aws_key_pair.myKey.key_name
    vpc_security_group_ids = [aws_default_security_group.demo-sg.id]
    subnet_id = var.subnet_id
    associate_public_ip_address = true
    tags = {
        Name = "${var.env}-ec2"
    }
   user_data = <<-EOF
                #! /bin/bash
                sudo apt-get update
                sudo apt-get install -y nginx
                sudo systemctl start nginx
                sudo systemctl enable nginx
                echo "<h1>Nginx Webserver Deployed via Terraform</h1>" | sudo tee /var/www/html/index.html
    EOF
}