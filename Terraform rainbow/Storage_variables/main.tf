variable "rg_name" {
  type = map(any)
}


resource "azurerm_resource_group" "RG" {
  for_each = var.rg_name
  name     = each.key
  location = each.value

}