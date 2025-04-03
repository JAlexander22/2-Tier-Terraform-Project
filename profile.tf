# Define IAM Role for Nginx
resource "aws_iam_role" "nginx_role" {
  name = "NginxInstanceRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

# IAM Policy to Allow DescribeInstances
resource "aws_iam_policy" "nginx_ec2_policy" {
  name        = "NginxEC2DescribePolicy"
  description = "Allows Nginx VM to describe EC2 instances"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = "ec2:DescribeInstances"
      Resource = "*"
    }]
  })
}

# Attach Policy to IAM Role
resource "aws_iam_role_policy_attachment" "nginx_ec2_attach" {
  role       = aws_iam_role.nginx_role.name
  policy_arn = aws_iam_policy.nginx_ec2_policy.arn
}

# Create IAM Instance Profile
resource "aws_iam_instance_profile" "nginx_profile" {
  name = "NginxInstanceProfile"
  role = aws_iam_role.nginx_role.name
}
