locals {
  sufix = "${var.tags.Project}-${var.tags.env}-${var.tags.region}" #recurso-cerberus-prod-virginia
}

# resource "random_string" "sufijo_s3" {
#   length  = 8
#   special = false
#   upper   = false
# }

# locals {
#   s3_sufix = "${var.tags.Project}-${random_string.sufijo_s3.id}"
# }

