
$openstack_host='10.1.70.90'
$env='sh1_vlan2'
$mysql_host = '10.1.70.91'
$rabbitmq_host = '10.1.70.91'

node /controller/ {

    class {'openstack::controller':
        mode => 'ha_all',
    } 

    class {'openstack::network': }

}

node /compute/ {

    class {'openstack::controller':
        mode => 'standard',
    } 
    
    class {'openstack::compute': }

}
