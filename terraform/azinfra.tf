# Create a New Resource Group

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group
  location = var.location
}

# Create a Virtual Network

resource "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network_name
  address_space       = ["${var.vnet_cidr}"]
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
}

# Create a Private Subnet

resource "azurerm_subnet" "subnet1" {
  name                 = var.azure_subnet1_name
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  address_prefix       = var.subnet1_cidr
}

# Create a Public Subnet

resource "azurerm_subnet" "subnet2" {
  name                 = var.azure_subnet2_name
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  address_prefix       = var.subnet2_cidr
}

# Create public IP
resource "azurerm_public_ip" "publicip" {
  name                = var.sap_public_ip
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  allocation_method   = "Static"
}


# Create Network Security Group and rule
resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg_name
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  security_rule {

    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTPS"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }


  security_rule {
    name                       = "HTTP_TEST"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }


  security_rule {
    name                       = "WINRDP"
    priority                   = 1004
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }


  security_rule {
    name                       = "HTTP"
    priority                   = 1005
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Create network interface
resource "azurerm_network_interface" "linuxnic" {
  name                = var.linuxnic
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  network_security_group_id = "${azurerm_network_security_group.nsg.id}"

  ip_configuration {
    name                          = "myNICConfg"
    subnet_id                     = "${azurerm_subnet.subnet1.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${azurerm_public_ip.publicip.id}"
  }
}

# Create network interface
resource "azurerm_network_interface" "winnic" {
  name                = var.winnic
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  network_security_group_id = "${azurerm_network_security_group.nsg.id}"

  ip_configuration {
    name                          = "mywinNICConfg"
    subnet_id                     = azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Dynamic"
#    public_ip_address_id          = azurerm_public_ip.publicip.id
  }
}


# Create a Linux virtual machine
resource "azurerm_virtual_machine" "vm" {
  name                  = var.linux_vm_name
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  network_interface_ids = [azurerm_network_interface.linuxnic.id]
  vm_size               = "Standard_DS14_v2"

  storage_os_disk {
    name              = "myOsDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "SUSE"
    offer     = "sles-sap-15-sp1"
    sku       = "gen2"
    version   = "2019.08.26"
  }

  os_profile {
    computer_name  = var.linux_os_profile_name
    admin_username = var.vm_username
    admin_password = var.vm_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
    ssh_keys {
    path     = var.ssh_keys_path
    key_data = var.ssh_keys_key_data
}
}
 }

#Create a Windows virtual machine
resource "azurerm_virtual_machine" "winvm" {
  name                  = var.azure_win_vm_name
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  network_interface_ids = [azurerm_network_interface.winnic.id]
  vm_size               = "Standard_DS2_v2"

  storage_os_disk {
    name              = "myWinOSDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }
storage_image_reference {
    publisher = "MicrosoftWindowsServerHPCPack"
    offer     = "WindowsServerHPCPack"
    sku       = "2016U1CN-WS2012R2"
    version   = "5.1.6086"
  }

  os_profile {
    computer_name  = var.win_os_profile_name
    admin_username = var.win_admin_username
    admin_password = var.win_admin_password
  }

  os_profile_windows_config {
    provision_vm_agent = true
}
 }

# Create disks which will be mount in ecs

resource "azurerm_managed_disk" "disk1" {
  name                 = var.disk1_name
  location             = "eastus"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  storage_account_type = "Premium_LRS"
  create_option        = "Empty"
  disk_size_gb         = var.disk1_size
}


resource "azurerm_managed_disk" "disk2" {
  name                 = var.disk2_name
  location             = "eastus"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  storage_account_type = "Premium_LRS"
  create_option        = "Empty"
  disk_size_gb         = var.disk2_size
}


resource "azurerm_managed_disk" "disk3" {
  name                 = var.disk3_name
  location             = "eastus"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  storage_account_type = "Premium_LRS"
  create_option        = "Empty"
  disk_size_gb         = var.disk3_size
}


resource "azurerm_managed_disk" "disk4" {
  name                 = var.disk4_name
  location             = "eastus"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  storage_account_type = "Premium_LRS"
  create_option        = "Empty"
  disk_size_gb         = var.disk4_size
}


resource "azurerm_managed_disk" "disk5" {
  name                 = var.disk5_name
  location             = "eastus"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  storage_account_type = "Premium_LRS"
  create_option        = "Empty"
  disk_size_gb         = var.disk5_size
}

resource "azurerm_virtual_machine_data_disk_attachment" "external" {
  managed_disk_id    = "${azurerm_managed_disk.disk1.id}"
  virtual_machine_id = "${azurerm_virtual_machine.vm.id}"
  lun                = "0"
  caching            = "ReadWrite"
}

resource "azurerm_virtual_machine_data_disk_attachment" "external2" {
  managed_disk_id    = "${azurerm_managed_disk.disk2.id}"
  virtual_machine_id = "${azurerm_virtual_machine.vm.id}"
  lun                = "1"
  caching            = "ReadWrite"
}

resource "azurerm_virtual_machine_data_disk_attachment" "external3" {
  managed_disk_id    = "${azurerm_managed_disk.disk3.id}"
  virtual_machine_id = "${azurerm_virtual_machine.vm.id}"
  lun                = "2"
  caching            = "ReadWrite"
}

resource "azurerm_virtual_machine_data_disk_attachment" "external4" {
  managed_disk_id    = "${azurerm_managed_disk.disk4.id}"
  virtual_machine_id = "${azurerm_virtual_machine.vm.id}"
  lun                = "3"
  caching            = "ReadWrite"
}

resource "azurerm_virtual_machine_data_disk_attachment" "external5" {
  managed_disk_id    = "${azurerm_managed_disk.disk5.id}"
  virtual_machine_id = "${azurerm_virtual_machine.vm.id}"
  lun                = "4"
  caching            = "ReadWrite"
}
