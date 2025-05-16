locals {
  tags = merge(
    var.tags,
    {
      Environment = var.env,
      Owner       = var.owner,
      Project     = var.project,
      CreatedBy   = "Terraform",
      ManagedBy   = "Terraform",
    },
  )
}
