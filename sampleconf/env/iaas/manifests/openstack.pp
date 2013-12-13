
# mandatory params

$openstack_host='10.100.10.1'
$env='iaas'


# configureable global params

$network_vlan_ranges = 'physnet1:1000:1200'
$physical_interface_mappings='physnet1:eth3'

node /controller/ {

    class {'openstack::controller':
        mode => 'standard',
    } 
}

node /network/ {
    class {'openstack::network': }
}

node /compute/ {
    class {'openstack::compute': }
}
