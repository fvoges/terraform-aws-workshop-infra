# Define the IAM Policy for the EC2 instance to run Terraform
resource "aws_iam_policy" "terraform_execution_policy" {
  name        = "TerraformEC2ExecutionPolicy"
  description = "IAM policy for EC2 instance to execute Terraform and manage AWS resources."

  # Policy document - Customize this carefully based on your needs!
  # The policy below is an example and should be restricted.
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "AllowTerraformToManageEC2",
        Effect = "Allow",
        Action = [
          "ec2:DescribeInstances",
          "ec2:DescribeImages",
          "ec2:DescribeKeyPairs",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSubnets",
          "ec2:DescribeVpcs",
          "ec2:RunInstances",
          "ec2:TerminateInstances",
          "ec2:CreateTags"
          // Add more EC2 permissions as required
        ],
        Resource = "*" // TODO: Scope down resources if possible
      },
      {
        Sid    = "AllowTerraformToManageS3State", // If using S3 backend
        Effect = "Allow",
        Action = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ],
        Resource = [
          "arn:aws:s3:::your-terraform-state-bucket-name",  // Bucket ARN
          "arn:aws:s3:::your-terraform-state-bucket-name/*" // Objects in bucket ARN
          // Add ARNs for other buckets Terraform might manage directly
        ]
      },
      {
        Sid    = "AllowTerraformToManageVPC",
        Effect = "Allow",
        Action = [
          "ec2:DescribeVpcs",
          "ec2:CreateVpc",
          "ec2:DeleteVpc",
          "ec2:DescribeSubnets",
          "ec2:CreateSubnet",
          "ec2:DeleteSubnet"
          // Add more VPC permissions as required
        ],
        Resource = "*" // TODO: Scope down resources if possible
      },
      {
        Sid    = "AllowListingForAllResources",
        Effect = "Allow",
        Action = [
          "ec2:Describe*",
          "iam:ListInstanceProfiles",
          "iam:ListRoles"
          // Add other necessary read-only/listing permissions
        ],
        Resource = "*"
      }
      // Add other statements for services like RDS, IAM, Route53 etc.
    ]
  })

  tags = {
    Provisioner = "Terraform"
    Purpose     = "EC2-Terraform-Execution"
  }
}

# Define the IAM Role that the EC2 instance will assume
resource "aws_iam_role" "terraform_execution_role" {
  name        = "TerraformEC2Role"
  description = "IAM role for EC2 instance to run Terraform."
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Provisioner = "Terraform"
    Purpose     = "EC2-Terraform-Execution"
  }
}

# Attach the policy to the role
resource "aws_iam_role_policy_attachment" "terraform_execution_attach" {
  role       = aws_iam_role.terraform_execution_role.name
  policy_arn = aws_iam_policy.terraform_execution_policy.arn
}

# Create the IAM Instance Profile and associate it with the role
resource "aws_iam_instance_profile" "terraform_ec2_instance_profile" {
  name = "${var.project}-bastion-instance-profile"
  # name = "TerraformEC2InstanceProfile" # This name will be used when launching EC2
  role = aws_iam_role.terraform_execution_role.name

  tags = {
    Provisioner = "Terraform"
    Purpose     = "EC2-Terraform-Execution"
  }
}

# Output the instance profile name for reference
output "terraform_ec2_instance_profile_name" {
  value       = aws_iam_instance_profile.terraform_ec2_instance_profile.name
  description = "The name of the IAM instance profile created for EC2 to run Terraform."
}

output "terraform_ec2_role_arn" {
  value       = aws_iam_role.terraform_execution_role.arn
  description = "The ARN of the IAM role created for EC2 to run Terraform."
}