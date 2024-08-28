locals {
  private_subnet_ids = [for subnet in module.private_subnet.subnets: subnet.id]
  public_subnet_ids  = [for subnet in module.public_subnet.subnets: subnet.id]
}

module "app_fleet" {
  source = "../../../common-modules/aws-ec2-fleet"

  name = "app-fleet"

  ingress_rules = {
    allow_app_port = {
      cidr_blocks      = [aws_vpc.main.cidr_block, var.cidr_blocks.externals.eu_central_1_vpc]
      source_port      = var.app_port
      destination_port = var.app_port
      protocol         = "tcp"
    }
  }

  scaling_config = {
    max_size = 5
    min_size = 0
  }

  tags = var.tags

  user_data = base64encode(
    templatefile("${path.module}/files/app-fleet-user-data.sh", {
      APP_PORT            = var.app_port
    })
  )

  vpc = {
    id         = aws_vpc.main.id
    subnet_ids = local.private_subnet_ids
  }
}

resource "aws_autoscaling_lifecycle_hook" "instance_launch_lifecycle_hook" {
  name                    = "launch-hook"
  autoscaling_group_name  = module.app_fleet.autoscaling_group.name
  default_result          = "CONTINUE"
  heartbeat_timeout       =  60 * 10 # 10 minutes
  lifecycle_transition    = "autoscaling:EC2_INSTANCE_LAUNCHING"
}

resource "aws_autoscaling_lifecycle_hook" "instance_termination_lifecycle_hook" {
  name                    = "termination-hook"
  autoscaling_group_name  = module.app_fleet.autoscaling_group.name
  default_result          = "CONTINUE"
  heartbeat_timeout       = 60 * 10 # 10 minute
  lifecycle_transition    = "autoscaling:EC2_INSTANCE_TERMINATING"
}
