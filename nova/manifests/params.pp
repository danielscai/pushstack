
class nova::params {

    $libvirt_vif_driver_linuxbridge = "nova.virt.libvirt.vif.QuantumLinuxBridgeVIFDriver"
    $linuxnet_interface_driver_linuxbridge = "nova.network.linux_net.LinuxBridgeInterfaceDriver"
    
    if $::enable_metadata_proxy {
        $enable_metadata_proxy = $::enable_metadata_proxy
    } else {
        $enable_metadata_proxy = false
    }

    if $::enable_config_drive {
        $enable_config_drive =$::enable_config_drive
    } else {
        $enable_config_drive = false
    }

    if $openstack::params::network_bridge {
        $network_bridge =  $openstack::params::network_bridge
    } else {
        $network_bridge = 'linuxbridge'
    }

    if $network_bridge == "linuxbridge" {
       $libvirt_vif_driver = $libvirt_vif_driver_linuxbridge
       $linuxnet_interface_driver = $linuxnet_interface_driver_linuxbridge
    } elsif $network_bridge == "ovs" {
       $libvirt_vif_driver = $libvirt_vif_driver_ovs
    }

    $libvirt_vif_driver_ovs = "nova.virt.libvirt.vif.LibvirtHybridOVSBridgeDriver"
    
    if $::libvirt_type {
        $libvirt_type = $::libvirt_type
    } else {
        if $::virtual != 'physical' {
            $libvirt_type = 'qemu'
        } else {
            $libvirt_type = 'kvm'
        }
    }

}

