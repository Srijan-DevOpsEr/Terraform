module "Dev_rg" {
  source = "../../Modules/Rgs"
  Rgs    = var.Rgs
}
module "Dev_Vnet" {
  source     = "../../Modules/vnets"
  depends_on = [module.Dev_rg]
  vnet       = var.vnet
}
module "Dev_Subnet" {
  source     = "../../Modules/subnets"
  depends_on = [module.Dev_Vnet]
  subs       = var.subs

}
module "Dev_vm" {
  source     = "../../Modules/VMs"
  depends_on = [module.Dev_Subnet]
  Vms        = var.Vms
}
module "Dev_nsg" {
  source     = "../../Modules/NSG"
  depends_on = [module.Dev_rg, module.Dev_Subnet]
  Nsg        = var.Nsg
}
# module "Dev_BH" {
#   source       = "../../Modules/BastionHost"
#   depends_on   = [module.Dev_vm, module.Dev_Subnet]
#   bastion_host = var.bastion_host
# }
module "Dev_kv" {
  source     = "../../Modules/Keyvaults"
  depends_on = [module.Dev_rg]
  Kvault      = var.Kvault
}

