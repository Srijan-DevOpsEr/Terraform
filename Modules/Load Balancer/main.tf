
resource "azurerm_public_ip" "PIP_LB" {
  name                = var.lb_mod.lb_ip_name
  location            = var.lb_mod.location
  resource_group_name = var.lb_mod.resource_group_name
  allocation_method   = "Static"
  sku                 = var.lb_mod.lb_sku
}

resource "azurerm_lb" "load_balancer" {
  name                = var.lb_mod.lb_name
  location            = var.lb_mod.location
  resource_group_name = var.lb_mod.resource_group_name
  sku                 = var.lb_mod.lb_sku
  frontend_ip_configuration {
    name                 = var.lb_mod.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.PIP_LB.id
  }
}

resource "azurerm_lb_rule" "lb_rule" {
  loadbalancer_id                = azurerm_lb.load_balancer.id
  name                           = var.lb_mod.lb_rule_name
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = var.lb_mod.frontend_ip_configuration_name
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.lb_be_pool.id]
  probe_id                       = azurerm_lb_probe.lb_probe.id
}

resource "azurerm_lb_backend_address_pool" "lb_be_pool" {
  loadbalancer_id = azurerm_lb.load_balancer.id
  name            = var.lb_mod.lb_be_pool_name
}

resource "azurerm_lb_probe" "lb_probe" {
 loadbalancer_id = azurerm_lb.load_balancer.id
  name            = var.lb_mod.lb_probe_name
  protocol            = "Tcp"
  port                = 80
  interval_in_seconds = 5
  number_of_probes    = 2
}

resource "azurerm_lb_backend_address_pool_address" "backendpool1" {
  for_each=var.lbpool_data_mod
  name                    = each.value.lb_be_pooladdress
  backend_address_pool_id = azurerm_lb_backend_address_pool.lb_be_pool.id
  virtual_network_id      = data.azurerm_virtual_network.vn_data[each.key].id
  ip_address              = data.azurerm_virtual_machine.vm_data[each.key].private_ip_address
}

data "azurerm_virtual_machine" "vm_data" {
  for_each=var.lbpool_data_mod
  name                = each.value.vm_name
  resource_group_name = each.value.resource_group_name
}

data "azurerm_virtual_network" "vn_data" {
  for_each=var.lbpool_data_mod
  name                = each.value.vn_name
  resource_group_name = each.value.resource_group_name
}