module "Virtual-carrybag" {
  source = "../../Modules/resource_groups"
  rg_map = var.rg_module
}
# module "Virtual-store_room" {
#   depends_on = [module.Virtual-carrybag]
#   source     = "../../Modules/Storage_accounts"
#   st_map     = var.st_module
# }
# module "virtual_container" {
#   depends_on = [module.Virtual-store_room]
#   source     = "../../Modules/Containers"
#   co_map     = var.co_module
# }
module "Virtual-net" {
  depends_on = [module.Virtual-carrybag]
  source     = "../../Modules/Vnets"
  vn         = var.vn_module
}
module "Virtual-subnet" {
  depends_on = [module.Virtual-net]
  source     = "../../Modules/Subnets"
  sub        = var.sub_module
}
module "Net-chalu" {
  depends_on = [module.Virtual-subnet]
  source     = "../../Modules/NIC"
  nic        = var.nic_module
}
module "Vmachine" {
  depends_on = [module.Net-chalu]
  source     = "../../Modules/VMs"
  vm         = var.vm_module
}
module "PIP" {
  depends_on = [ module.Virtual-carrybag ]
  source = "../../Modules/PIP"
  pip = var.pip_module
}