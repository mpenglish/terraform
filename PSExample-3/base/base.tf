# Configure the VMware vSphere Provider
provider "vsphere" {
  user           = "${var.viuser}"
  password       = "${var.vipassword}"
  vsphere_server = "${var.viserver}"

  # if you have a self-signed cert
  allow_unverified_ssl = true
}

/*
resource "vsphere_folder" "TerraformFrontEnd" {
    datacenter_id = "${data.vsphere_datacenter.dc.id}"
    path = "NUIT-CENTRAL/ISG/Mail/Exchange/TerraformFrontEnd"
    type = "vm"
}


data "vsphere_datacenter" "dc" {
    name = "IT Service Datacenter"
}
data "vsphere_datastore" "datastore" {
  name          = "ESXMG2-Store1-Vol01"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_resource_pool" "pool" {
  name          = "SMED Resource Pool"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network" {
  name          = "MachineRoom-vlan233"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

provisioner "local-exec" {
        command = "invoke-command -scriptblock {get-date > complated.txt} -computername automation"
        interpreter = ["PowerShell", "-Command"]

        connection {
            type     = "winrm"
            user     = "sme47@campus.ncl.ac.uk"
            password = "${var.domain_password}"
        }
    }



*/

resource "vsphere_folder" "Exchange" {
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
  path          = "NUIT-CENTRAL/ISG/Exchange"
  type          = "vm"
}

data "vsphere_datacenter" "dc" {
  name = "IT Service Datacenter"
}

data "vsphere_datastore" "datastore" {
  name          = "Compstor01-VMware-Vol07"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_resource_pool" "pool" {
  name          = "Resources"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

#Private ISG Datacentre Private vlan
data "vsphere_network" "ISG-Datacenter-Private" {
  name          = "_VLAN3016-ISG-Datacenter-Servers-PRIVATE"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

#Private ISG Datacentre Public vlan
data "vsphere_network" "ISG-Datacenter-Public" {
  name          = "VLAN3024-ISG-Datacenter-Servers-PUBLIC"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

#Template we want to use
data "vsphere_virtual_machine" "template" {
  name          = "${var.vm_template}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

#Category we want to use
data "vsphere_tag_category" "category" {
  name = "VMAttributes"
}

resource "vsphere_tag" "tag" {
  name        = "${format("${var.name}%02d",count.index+1)}"
  category_id = "${data.vsphere_tag_category.category.id}"
  description = "${}"
  #"${substr(replace(timeadd(timestamp(),"10m"), "-","/"),0,10)}:::nuit-isg@newcastle.ac.uk"
}

resource "vsphere_virtual_machine" "terraform-web" {
  count            = "${length(var.hostips)}"
  name             = "${format("${var.name}%02d",count.index+1)}"
  folder           = "${vsphere_folder.Exchange.path}"
  resource_pool_id = "${data.vsphere_resource_pool.pool.id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"

  #cluster = "Production VMs"
  num_cpus               = "${var.num_cpus}"
  memory                 = "${var.memory}"
  guest_id               = "windows9Server64Guest"
  annotation             = "${var.annotation}"
  cpu_hot_add_enabled    = "true"
  memory_hot_add_enabled = "true"
  scsi_type              = "lsilogic-sas"
  tags                   = ["${vsphere_tag.tag.id}"]

  disk {
    label = "disk0"
    size  = 40
  }

  network_interface {
    network_id     = "${data.vsphere_network.ISG-Datacenter-Public.id}"
    adapter_type   = "vmxnet3"
    use_static_mac = true
    mac_address    = "${var.hostmacs[count.index]}"
  }

  clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"

    customize {
      windows_options {
        computer_name         = "${format("${var.name}%02d",count.index+1)}"
        admin_password        = "${var.local_password}"
        join_domain           = "testncl.ncl.ac.uk"
        domain_admin_user     = "marke@testncl.ncl.ac.uk"
        domain_admin_password = "${var.domain_password}"
        full_name             = "Administrator"
        organization_name     = "Newcastle University"
        time_zone             = 85

        #run_once_command_list = [
        #  "powershell.exe -command set-netconnectionprofile -interfacealias Ethernet0 -networkcategory Private",
        #  "powershell.exe -command logoff",
        #]
      }

      network_interface {
        ipv4_address = "${var.hostips[count.index]}"
        ipv4_netmask = 22

        dns_server_list = [
          "10.3.195.77",
          "10.3.195.101",
        ]
      }

      ipv4_gateway = "128.240.208.1"
    }

    #network_interface {
    #    network_id   = "${data.vsphere_network.ISG-Datacenter-Private.id}"

    #}
  }
}
