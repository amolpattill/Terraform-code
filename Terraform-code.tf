provider "aws" {
  region                  = "ap-south-1"
  profile                 = "approfile"
}
resource "tls_private_key" "this" {
  algorithm = "RSA"
}

resource "aws_key_pair" "kp1" {

  key_name   = "mykeyy"
  public_key = tls_private_key.this.public_key_openssh
}

resource "aws_security_group" "example" {
  name = "my group"
  

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

 
}




resource "aws_instance" "myin" {
  ami           = "ami-0447a12f28fddb066"
  instance_type = "t2.micro"
   key_name = aws_key_pair.kp1.key_name
   security_groups = ["launch-wizard-2"]

  tags = {
    Name = "HelloWorld"
  }
}

resource "aws_ebs_volume" "example1" {
  availability_zone = aws_instance.myin.availability_zone
  size              = 1

  tags = {
    Name = "Volume1"
  }
}

resource "aws_volume_attachment" "vol-attach" {
  device_name = "/dev/sdc"
  volume_id   = "${aws_ebs_volume.example1.id}"
  instance_id = "${aws_instance.myin.id}"
}




