locals {
  tags = merge(
    var.tags,
    {
      Project = var.project,
    },
  )
}
