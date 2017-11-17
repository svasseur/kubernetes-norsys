#!/bin/sh
# William Lam
# www.virtuallyghetto.com
# Auto Geneated script to automate the conversion of VMDK & regiration of CoreOS VM

# Change to CoreOS directory
cd /vmfs/volumes/Datastore-02/coreos-workerbee01

# Convert VMDK from 2gbsparse from hosted products to Thin
vmkfstools -i coreos_production_vmware_image.vmdk -d thin coreos.vmdk

# Remove the original 2gbsparse VMDKs
rm coreos_production_vmware_image.vmdk

# Update CoreOS VMX to reference new VMDK
sed -i 's/coreos_production_vmware_image.vmdk/coreos.vmdk/g' coreos_production_vmware.vmx

# Update CoreOS VMX w/new VM Name
sed -i "s/displayName.*/displayName = \"coreos-workerbee01\"/g" coreos_production_vmware.vmx

# Update CoreOS VMX to map to VM Network
echo "ethernet0.networkName = \"Prod\"" >> coreos_production_vmware.vmx

# Update CoreOS VMX to include CD-ROM & mount cloud-config ISO
cat >> coreos_production_vmware.vmx << __CLOUD_CONFIG_ISO__
ide0:0.deviceType = "cdrom-image"
ide0:0.fileName = "workerbee01-config.iso"
ide0:0.present = "TRUE"
__CLOUD_CONFIG_ISO__

# Register CoreOS VM which returns VM ID
VM_ID=$(vim-cmd solo/register /vmfs/volumes/Datastore-02/coreos-workerbee01/coreos_production_vmware.vmx)

# Upgrade CoreOS Virtual Hardware from 4 to 9
vim-cmd vmsvc/upgrade ${VM_ID} vmx-09

# PowerOn CoreOS VM
vim-cmd vmsvc/power.on ${VM_ID}
echo "VM coreos-workerbee01 is now running using hostname: workerbee01"
#The first time coreos boots up, it will use DHCP to get a random IP address.  Later in the boot process, coreos will write the static.network file which overrides the DHCP behavior for the next boot.
#This workaround reboots this new server to allow it to use this static IP
#echo "Wating 60 seconds for power.on"
#sleep 60
#vim-cmd vmsvc/power.shutdown ${VM_ID}
#echo "Waiting for power.off"
#while vim-cmd vmsvc/power.getstate ${VM_ID} | grep on; do
#  echo -n "."
#  sleep 1
#done
#vim-cmd vmsvc/power.on ${VM_ID}



