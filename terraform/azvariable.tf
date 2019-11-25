/* Configure Azure Provider and declare all the Variables that will be used in Terraform configurations */

variable "location" {
  default = "East US"
  description = "The default Azure region for the resource provisioning"
}

variable "resource_group" {
  default = "OS-Factory"
  description = "Resource group name that will contain various resources"
}

variable "virtual_network_name" {
  default = "SAPNet"
  description = "Virtual Network name"
}

variable "vnet_cidr" {
  default = "10.1.0.0/16"
  description = "CIDR block for Virtual Network like 10.1.0.0/16"
}

variable "azure_subnet1_name" {
  default = "SAP_Private_sub"
  description = "Private Subnet name"
}

variable "subnet1_cidr" {
  default = "10.1.0.0/24"
  description = "CIDR block for Private Subnet within a Virtual Network"
}


variable "azure_subnet2_name" {
  default = "SAP_Public_sub"
  description = "Public Subnet name"
}


variable "subnet2_cidr" {
  default = "10.1.1.0/24"
  description = "CIDR block for Subnet within a Virtual Network"
}


variable "sap_public_ip" {
  default = "sap_public_ip"
  description = "Public IP Allocation"
}


variable "nsg_name" {
  default = "mysg"
  description = "Network Security Group and Rule"
}

variable "linuxnic" {
  default = "mylinuxnic"
  description = "Network Interface"
}

variable "winnic" {
  default = "mywinnic"
  description = "Network Interface"
}

variable "linux_vm_name" {
  default = "saphanalinuxVM"
  description = "Linux virtual machine name"
}

variable "linux_os_profile_name" {
  default = "myVM"
  description = "Linux virtual machine name"
}


variable "vm_username" {
  default = "cloud"
  description = "Enter admin username to SSH into Linux VM"
}

variable "vm_password" {
  default = "welcome@1234"
  description = "Enter admin password to SSH into VM"
}

variable "ssh_keys_path" {
  default = "/home/cloud/.ssh/authorized_keys"
  description = "Enter path of user to be passwordless"
}

variable "ssh_keys_key_data" {
  default = "ssh-rsa AAAAB3N"
  description = "Enter public key which need to insert into linux vm"
}

variable "azure_win_vm_name" {
  default = "win-rdp"
  description = " Windows virtual machine name"
}

variable "win_os_profile_name" {
  default = "winrdp"
  description = "Linux virtual machine name"
}

variable "win_admin_username" {
  default = "cloud"
  description = "Admin user name of windows vm"
}

variable "win_admin_password" {
  default = "welcome@1234"
  description = "Admin password for windows vm"
}


variable "disk1_name" {
  default = "saphana_DataDisk_0"
  description = "Disk1  name for sap hana"
}

variable "disk1_size" {
  default = "70"
  description = "Disk1 size for sap hana"
}



variable "disk2_name" {
  default = "saphana_DataDisk_1"
  description = "Disk2  name for sap hana"
}

variable "disk2_size" {
  default = "200"
  description = "Disk2 size for sap hana"
}

variable "disk3_name" {
  default = "saphana_DataDisk_2"
  description = "Disk3  name for sap hana"
}

variable "disk3_size" {
  default = "40"
  description = "Disk3 size for sap hana"
}

variable "disk4_name" {
  default = "saphana_DataDisk_3"
  description = "Disk4  name for sap hana"
}

variable "disk4_size" {
  default = "50"
  description = "Disk4 size for sap hana"
}

variable "disk5_name" {
  default = "saphana_DataDisk_4"
  description = "Disk5  name for sap hana"
}

variable "disk5_size" {
  default = "50"
  description = "Disk5 size for sap hana"
}

# Following variable is use for authentication azure from terraform

variable "subscription_id" {
  default = "c11866fc-33f7-4c1d-821ffeeeef"
  description = "Mention subscription_id"
}

variable "client_id" {
  default = "9920d203-e59e-4765-bfefefefe89b97cf"
  description = "Mention client_id  mention in appid"
}

variable "client_secret" {
  default = "e96539ac-15a7-433e-850wfefwewec95c6946"
  description = "Mention client_secret  mention in password"
}

variable "tenant_id" {
  default = "b7dd56dd-ba50-462f-abffwewwea233d6"
  description = "Mention tenant_id"
}
