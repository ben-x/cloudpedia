# resource "aws_vpc_endpoint_service" "app_vpc_endpoint_service" {
#   acceptance_required        = true
#   network_load_balancer_arns = [module.app_nlb.arn]
#
#   tags = merge(var.tags, {
#     Name = "app-endpoint"
#   })
# }
