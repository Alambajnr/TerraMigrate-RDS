resource "aws_iam_role" "dms-vpc-role" {
  name        = "dms-vpc-role"
  description = "Allows DMS to manage VPC"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "dms.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "example" {
  role       = aws_iam_role.dms-vpc-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonDMSVPCManagementRole"
}

resource "aws_dms_replication_subnet_group" "example" {
  replication_subnet_group_description = "Example"
  replication_subnet_group_id          = "example-id"

  subnet_ids = [
    "subnet-080934cd125c8a544", "subnet-0194b82d670469b4e", 
    "subnet-06f94ab6b4606e107", "subnet-023c7d58d5f06fdcf", 
    "subnet-070ad34250b5830d0", "subnet-07f534d3300928ad4"
    ]

  tags = {
    Name = "example-id"
  }

  # explicit depends_on is needed since this resource doesn't reference the role or policy attachment
  depends_on = [aws_iam_role_policy_attachment.example]
}
