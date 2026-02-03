# resource "local_file" "productos" {
#   count    = 4
#   content  = "productos para el mes proximo"
#   filename = "producto-${random_string.sufijo[count.index].id}.txt"

# }

# resource "random_string" "sufijo" {
#   count   = 5
#   length  = 8
#   special = false
#   upper   = false
#   numeric = false
# }
