data "aws_ami" "ubuntu_server_22" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_iam_instance_profile" "main" {
  name = "${var.name}-ec2-instance-profile"
  role = aws_iam_role.main.name
}

resource "aws_launch_template" "main" {
  name_prefix   = var.name
  image_id      = data.aws_ami.ubuntu_server_22.id
  instance_type = var.instance_config.instance_type
  instance_initiated_shutdown_behavior = "terminate"

  iam_instance_profile {
    arn  = aws_iam_instance_profile.main.arn
  }

  credit_specification {
    cpu_credits = "unlimited"
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  monitoring {
    enabled = true
  }

  network_interfaces {
    associate_public_ip_address = var.instance_config.associate_public_ip_address
    security_groups = [aws_security_group.main.id]
  }

  user_data = var.user_data
}
