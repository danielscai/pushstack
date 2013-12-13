class openstack::network (
    $network_mode = $openstack::params::network_mode,
    $network_bridge = $openstack::params::network_bridge,
    $enable_lbaas = $openstack::params::enable_lbaas,
    $enable_l3 = $openstack::params::enable_l3,
    $enable_dhcp = $openstack::params::enable_dhcp,
    $enable_metadata = $openstack::params::enable_metadata,
    $dhcp_domain = $openstack::params::dhcp_domain,
    $physical_interface_mappings = $openstack::params::physical_interface_mappings,

    ) inherits openstack::params {

    include provision
    include openstack::repo
    Class['openstack::repo'] -> Class['openstack::network']

    if $network_bridge == "linuxbridge" {
        # legacy code for network physnet mapping 
        # can be removed 
        #if $::physical_interface_mappings_network {
        #    $physical_interface_mappings_tmp = $::physical_interface_mappings_network
        #} else {
        #    $physical_interface_mappings_tmp = $physical_interface_mappings
        #}
        #class {'neutron::agent::linuxbridge': 
        #    physical_interface_mappings => $physical_interface_mappings_tmp 
        #}
        include neutron::agent::linuxbridge
    } elsif $network_bridge == "ovs" {
        include neutron::agent::ovs
    }


    if $enable_dhcp {
        class {'neutron::agent::dhcp':  
            network_bridge => $network_bridge,
            dhcp_domain => $openstack::network::dhcp_domain,
        }
    }

    class {'neutron::agent::l3': 
        network_bridge => $network_bridge,
        enable_l3   => $openstack::network::enable_l3,
    }

    if $enable_lbaas {
        class {'neutron::agent::lbaas': 
            network_bridge => $network_bridge
        }
    }
    
    if $enable_metadata { 
        class {'neutron::agent::metadata': }
    }
}
