resource "aws_dms_replication_instance" "dms-instance" {
  allocated_storage          = 30
  apply_immediately          = true
  auto_minor_version_upgrade = false
  multi_az                   = false
  publicly_accessible        = true
  replication_instance_class = "dms.t3.small"
  replication_instance_id    = "dms-instance"
  replication_subnet_group_id  = aws_dms_replication_subnet_group.example.id
#  vpc_security_group_ids       = [aws_security_group.dms.id]
 
  tags = {
    Name = "DMS-Replication-Instance"
  }

}



resource "aws_dms_endpoint" "source_endpoint" {
  endpoint_id = "terraform-src"
  endpoint_type       = "source"
  engine_name         = "mysql"
  username            = ""
  password            = ""
  server_name         = "terraform-sourcedb.cwh0ya6qip7k.us-east-1.rds.amazonaws.com" # Replace with the source RDS endpoint
  port                = 3306
  extra_connection_attributes = "initstmt=SET FOREIGN_KEY_CHECKS=0;" # Optional: Disable foreign key checks during migration
}

resource "aws_dms_endpoint" "target_endpoint" {
  endpoint_id = "myseconddb"
  endpoint_type       = "target"
  engine_name         = "mysql"
  username            = ""
  password            = ""
  server_name         = "myseconddb.cwh0ya6qip7k.us-east-1.rds.amazonaws.com" # Replace with the target RDS endpoint
  port                = 3306
}

resource "aws_dms_replication_task" "example_replication_task" {
  replication_task_id             = "example-replication-task"
  migration_type                  = "full-load"
    replication_instance_arn = aws_dms_replication_instance.dms-instance.replication_instance_arn
  source_endpoint_arn      = aws_dms_endpoint.source_endpoint.endpoint_arn
  target_endpoint_arn             = aws_dms_endpoint.target_endpoint.endpoint_arn
  table_mappings                  = <<EOF
{
  "rules": [
    {
      "rule-type": "selection",
      "rule-id": "1",
      "rule-name": "1",
      "object-locator": {
        "schema-name": "ecommerce_migration_demo", 
        "table-name": "%"
      },
      "rule-action": "include",
      "rule-action": "include"
    }
  ]
}
EOF
}



/*# This automatically finds your default VPC
data "aws_vpc" "default" {
  default = true
}

# Now use it in your Security Group
resource "aws_security_group" "dms_sg" {
  name   = "dms-replication-sg"
  vpc_id = data.aws_vpc.default.id # Uses the ID found above

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_dms_replication_instance" "dms-instance" {
  allocated_storage          = 30
  apply_immediately          = true
  auto_minor_version_upgrade = false
  multi_az                   = false
  publicly_accessible        = true
  replication_instance_class = "dms.t3.small"
  replication_instance_id    = "dms-instance"
  replication_subnet_group_id = aws_dms_replication_subnet_group.example.id
  
  # Ensure the DMS instance has a security group that can talk to your RDS instances
  vpc_security_group_ids      = [aws_security_group.dms_sg.id] 

  tags = {
    Name = "DMS-Replication-Instance"
  }
}

resource "aws_dms_endpoint" "source_endpoint" {
  endpoint_id   = "terraform-src"
  endpoint_type = "source"
  engine_name   = "mysql"
  username      = "admin"
  password      = "yourpassword"
  server_name   = "terraform-sourcedb.cwh0ya6qip7k.us-east-1.rds.amazonaws.com"
  port          = 3306
  # Extra attributes are usually better on the Target for MySQL
}

resource "aws_dms_endpoint" "target_endpoint" {
  endpoint_id   = "myseconddb-target"
  endpoint_type = "target"
  engine_name   = "mysql"
  username      = "admin"
  password      = "2ndpassword"
  server_name   = "myseconddb.cwh0ya6qip7k.us-east-1.rds.amazonaws.com"
  port          = 3306
  # Move the Foreign Key check disable here - it's a Target setting
  extra_connection_attributes = "initstmt=SET FOREIGN_KEY_CHECKS=0;" 
}

resource "aws_dms_replication_task" "example_replication_task" {
  replication_task_id      = "ecommerce-migration-task"
  migration_type           = "full-load-and-cdc" # Changed to include CDC for your demo!
  replication_instance_arn = aws_dms_replication_instance.dms-instance.replication_instance_arn
  source_endpoint_arn      = aws_dms_endpoint.source_endpoint.endpoint_arn
  target_endpoint_arn      = aws_dms_endpoint.target_endpoint.endpoint_arn

  # Fixed the duplicate "rule-action" and the schema name to match the script I gave you
  table_mappings = jsonencode({
    rules = [
      {
        rule-type = "selection"
        rule-id   = "1"
        rule-name = "1"
        object-locator = {
          schema-name = "ecommerce_migration_demo" # Matches the SQL script provided earlier
          table-name  = "%"
        }
        rule-action = "include"
      }
    ]
  })
}*/