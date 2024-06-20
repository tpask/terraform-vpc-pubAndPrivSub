data "http" "my_ip" { url = "http://checkip.amazonaws.com/"}

#add pubkey to AWS
resource "aws_key_pair" "add_key" {
  key_name   = var.project
  public_key = file(var.pubkey_file)
}

#create security groups
resource "aws_security_group" "allow_ssh" {
  name        = var.project
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
  tags = var.tags
  lifecycle { ignore_changes = [tags["Create_date_time"], ] }
}

resource "aws_instance" "public" {
  for_each = var.AMIS
  ami      = each.value
  
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
      Name        = "${var.project}- ${each.key}"
      Environment = var.environment
      owner = "tp"
      Create_date_time = formatdate("YYYY-MM-DD hh:mm:ss ZZZ", timestamp())
  }
  lifecycle { ignore_changes = [tags["Create_date_time"], ] }
}