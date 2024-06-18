# generate a random number
resource "random_integer" "number" {
  min = 10
  max = 999
}

data "http" "my_ip" { url = "http://checkip.amazonaws.com/"}

#add pubkey to AWS
resource "aws_key_pair" "add_key" {
  key_name   = "${var.nameHeader}-${random_integer.number.result}"
  public_key = file(var.pubkey_file)
}

#create security groups
resource "aws_security_group" "allow_ssh" {
  name        = "${var.nameHeader}-${random_integer.number.result}"
  description = "Allow all inbound connections from my workstaion"
  vpc_id      = var.vpc_id
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${chomp(data.http.my_ip.response_body)}/32"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Owner = "${var.owner} - allow all to my address only",
    Name = "${var.nameHeader}-${random_integer.number.result}"
  }
}

resource "aws_instance" "public" {
  # ami                         = var.ami == "" ? data.aws_ami.ubuntu.id : var.ami
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.add_key.key_name
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.other_sg_ids == "" ? [aws_security_group.allow_ssh.id] : [var.other_sg_ids, aws_security_group.allow_ssh.id]
  associate_public_ip_address = true
  user_data = local.instance-userdata
  metadata_options { http_tokens = "required" }
  # root disk
  root_block_device {
    volume_size           = var.volume_size
    volume_type           = "gp2"
  }
  tags = {
    Name = "public-${var.nameHeader}"
     Owner = "${var.owner}"
  }
}