# create a CloudWatch log group for VPC Flow Logs
resource "aws_cloudwatch_log_group" "vpc_flow_logs" {
  name = "/aws/vpc/flow-logs"

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [name]
  }
}

# enable vpc flow logs to capture traffic information
# Create an IAM role for VPC Flow Logs
resource "aws_iam_role" "vpc_flow_log_role" {
  name = "vpcFlowLogRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        }
      }
    ]
  })
}

# Attach the necessary policy to the IAM role
resource "aws_iam_role_policy" "vpc_flow_log_policy" {
  name   = "vpcFlowLogPolicy"
  role   = aws_iam_role.vpc_flow_log_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_flow_log" "vpc_flow_logs" {
  log_destination = aws_cloudwatch_log_group.vpc_flow_logs.arn
  log_destination_type = "cloud-watch-logs"
  traffic_type = "ALL"
  vpc_id = aws_vpc.main.id
  iam_role_arn = aws_iam_role.vpc_flow_log_role.arn
}

# create a CloudWatch log group for security group logs
resource "aws_cloudwatch_log_group" "security_group_logs" {
  name = "/aws/security-group/log"

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [name]
  }
}

# create a CloudWatch log group for VPN Gateway logs (if it's enabled)
resource "aws_cloudwatch_log_group" "vpn_gateway_logs" {
  count = var.enable_vpn_gateway ? 1 : 0
  name = "/aws/vpn-gateway/log"

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [name]
  }
}

# create a CloudWatch logstream for vpc flow logs
resource "aws_cloudwatch_log_stream" "vpc_flow_log_stream" {
    name = "vpc-flow_log-stream"
    log_group_name = aws_cloudwatch_log_group.vpc_flow_logs.name
}

# create a CloudWatch logstream for security group logs
resource "aws_cloudwatch_log_stream" "security_group_log_stream" {
    name = "security-group_log-stream"
    log_group_name = aws_cloudwatch_log_group.security_group_logs.name
}

# create a CloudWatch logstream for VPN Gateway logs
resource "aws_cloudwatch_log_stream" "vpn_gateway_log_stream" {
    count = var.enable_vpn_gateway ? 1 : 0
    name = "vpn-gateway_log-stream"
    log_group_name = aws_cloudwatch_log_group.vpn_gateway_logs[count.index].name
}