#Sample infrastructure vars.tf

variable "viuser" {}
variable "vipassword" {}

variable "viserver" {
  default = "vcenter65.ncl.ac.uk"
}

variable "domain_password" {}
variable "local_password" {}

variable "name" {
  default = "testnclexch"
}

#IP addresses and macs for vms
/*
0..1 | foreach{
$count = 0
write-output "variable ""hostips"" { `n`tdefault = {"
 [char[]]([int][char]'a'..[int][char]'d') | foreach{
    $inventry = Get-InventoryEntry -ComputerName "pod01-ct-$_"
    Write-Output "`t`t""$count"" = ""$($inventry.IP)"""

    $count ++
}
Write-output "`t} `n}"

$count = 0
write-output "variable ""hostmacs"" { `n`tdefault = {"
 [char[]]([int][char]'a'..[int][char]'d') | foreach{
    $inventry = Get-InventoryEntry -ComputerName "pod01-ct-$_"
    Write-Output "`t`t""$count"" = ""$($inventry.mac)"""

    $count ++
}
Write-output "`t} `n}"
*/

variable "annotation" {
  default = "##TEST##"
}

variable "hostips" {
  default = {
    "0" = "128.240.208.130"

    #"1" = "128.240.208.131"
    #"2" = "128.240.208.132"
    #"3" = "128.240.208.133"
  }
}

variable "hostmacs" {
  default = {
    "0" = "00:50:56:3c:03:60"

    #"1" = "00:50:56:3c:03:61"
    #"2" = "00:50:56:3c:03:62"
    #"3" = "00:50:56:3c:03:63"
  }
}

variable "num_cpus" {
  default = 4
}

variable "memory" {
  default = 4096
}

variable "vm_template" {
  default = "T-Win2016D-terraform"
}

/*
// default VM name in vSphere and its hostname
variable "vmname" {
  default = "test-vm"
}

// default Resource Pool
variable "vmrp" {
  default = "FIRST_RP"
}

// default VM domain for guest customization
variable "vmdomain" {
  default = "local.domain"
}

// default datastore to deploy vmdk
variable "vmdatastore" {
  default = "SILVER_01"
}

// default VM Template
variable "vmtemp" {
  default = "CENTOS-TEMP"
}

// map of the datastore clusters (vmdatastore = "vmdscluster")
variable "vmdscluster" {
  type = "map"
  default = {
    SILVER_01 = "SILVER_DSCLUSTER"
    SILVER_02 = "SILVER_DSCLUSTER"
    GOLD_01 = "GOLD_DSCLUSTER"
    GOLD_02 = "GOLD_DSCLUSTER"
  }
}

// map of the compute clusters (vmrp = "vmcluster")
variable vmcluster {
  type = "map"
  default = {
    FIRST_RP = "FIRST_CLUSTER"
    SECOND_RP = "FIRST_CLUSTER"
    ANOTHER_RP = "SECOND_CLUSTER"
    SOME_RP = "SECOND_CLUSTER"
  }
}

// map of the first three octets of the IP address (with netmask /24, vmdomain = "vmaddrbase")
variable "vmaddrbase" {
  type = "map"
  default = {
    local.domain = "192.168.0."
    second.domain = "192.168.1."
  }
}

// host octet in the IP address
variable "vmaddroctet" {
  default = "200"
}

// map of the IP gateways (vmdomain = "vmgateway")
variable "vmgateway" {
  type = "map"
  default = {
    local.domain = "192.168.0.1"
    second.domain = "192.168.1.1"
  }
}

// map of the DNS1 addresses (vmdomain = "vmdns1")
variable "vmdns1" {
  type = "map"
  default = {
    local.domain = "192.168.0.5"
    second.domain = "192.168.1.5"
  }
}

// map of the DNS2 addresses (vmdomain = "vmdns2")
variable "vmdns2" {
  type = "map"
  default = {
    local.domain = "192.168.0.6"
    second.domain = "192.168.1.6"
  }
}

// map of the VM Network (vmdomain = "vmnetlabel")
variable "vmnetlabel" {
  type = "map"
  default = {
    local.domain = "NET_Backend_01"
  }
}

*/

