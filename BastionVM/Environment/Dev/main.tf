module "rg-module" {
  source = "../../modules/rg"
  vms    = var.vm-details
}
module "vn-module" {
  depends_on = [module.rg-module]
  source     = "../../modules/vn"
  vms        = var.vm-details
}
module "sub-module" {
  depends_on = [module.vn-module]
  source     = "../../modules/sub"
  vms        = var.vm-details
  bas        = var.bastion-details
}
module "pip-module" {
  depends_on = [module.rg-module]
  source     = "../../modules/pip"
  bas        = var.bastion-details
}
module "bastion-module" {
  depends_on = [module.pip-module, module.sub-module]
  source     = "../../modules/bastion"
  bas        = var.bastion-details
}
module "keyvault-module" {
  depends_on = [module.rg-module]
  source     = "../../modules/keyvault"
  keyvault   = var.keyvault-details
}
module "secrets-module" {
  depends_on = [module.keyvault-module]
  source     = "../../modules/secrets"
  secret     = var.secret-details
}
module "nic-module" {
  depends_on = [module.sub-module]
  source     = "../../modules/nic"
  vms        = var.vm-details
}

module "vm-module" {
  depends_on = [module.nic-module, module.secrets-module]
  source     = "../../modules/vm"
  vms        = var.vm-details
}
