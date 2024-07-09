resource "aws_iam_role" "main" {
  name                 = "${var.name}-ec2-instance-role"
  description          = "EC2 instance role for ${var.name}"
  assume_role_policy   = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_policy" "main" {
  name = "${var.name}-ec2-instance-role"
  description = "EC2 instance role policy for ${var.name}"

  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = concat(
      [
        for key, policy in var.additional_iam_policy_json : policy
      ],
      [
        {
          Effect = "Allow"
          Action = [
            "ec2:DescribeTags",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ],
          Resource = "*"
        }
      ]
    )
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "main" {
  policy_arn = aws_iam_policy.main.arn
  role       = aws_iam_role.main.name
}
