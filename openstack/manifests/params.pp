class openstack::params {
    # configureable params 

    if ! $::openstack_host {
        fail(" Global variable 'openstack_host' not defined ! please define before deploy openstack")
    }
    $openstack_host = $::openstack_host
    $vip=$::openstack_host

    #if ! $::env {
    #    fail(" Global variable 'env' not defined, exist")
    #}

    # params with default value assigned 
    if $::enable_hotfix {
        $enable_hotfix = $::enable_hotfix
    } else {
        $enable_hotfix = True
    }


    if $::mysql_host {
        $mysql_vip = $mysql_host
    } else {
        $mysql_vip=$vip
    }

    if $::rabbitmq_host {
        $rabbitmq_vip = $::rabbitmq_host
    } else {
        $rabbitmq_vip=$vip
    }

    if $::api_bind_ip {
        $api_bind_ip=$::api_bind_ip
    }else {
        $api_bind_ip=$::ipaddress
    }
    
    if $::mysql_bind_ip {
        $mysql_bind_ip = $::mysql_bind_ip
    } else { 
        $mysql_bind_ip = $api_bind_ip
    }
    
    if $::rabbitmq_bind_ip {
        $rabbitmq_bind_ip = $::rabbitmq_bind_ip
    } else {
        $rabbitmq_bind_ip =$api_bind_ip
    }

    if $::apache_bind_ip {
        $apache_bind_ip = $::apache_bind_ip
    } else {
        $apache_bind_ip = $api_bind_ip
    }

    if $::network_mode {
        $network_mode = $::network_mode
    } else {
        $network_mode='vlan' 
    }

    if $::network_bridge {
        $network_bridge = $::network_bridge
    } else {
        $network_bridge = 'linuxbridge'
    }
    
    if $::network_vlan_ranges {
        $network_vlan_ranges = $::network_vlan_ranges
    } else {
        $network_vlan_ranges = 'physnet1:2:4094'
    }
    
    if $::physical_interface_mappings {
        $physical_interface_mappings = $::physical_interface_mappings
    } else {
        $physical_interface_mappings = "physnet1:eth1" 
    }

    if $::security_group_api {
        $security_group_api = $security_group_api
    } else {
        $security_group_api = 'quantum'
    }

    if $::dhcp_domain {
        $dhcp_domain = $::dhcp_domain
    } else {
        $dhcp_domain = 'local'
    }

    if $::enabled_backends {
        $cinder_enabled_backends = $::enabled_backends
    }
        
    # listen ip address binding

    $keystone_api_ip=$api_bind_ip
    $nova_metadata_ip = $api_bind_ip
    $nova_api_ip=$api_bind_ip
    $ec2_api_ip=$api_bind_ip
    $metadata_api_ip=$api_bind_ip
    $vncserver_proxyclient_ip=$api_bind_ip
    $glance_api_ip=$api_bind_ip
    $cinder_api_ip=$api_bind_ip
    $quantum_api_ip=$api_bind_ip

    # service provider ip 

    $nova_vip_ip=$vip
    $keystone_vip_ip=$vip
    $glance_vip_ip=$vip
    $quantum_vip_ip=$vip
    $cinder_vip_ip=$vip

    $mysql_server_host= $mysql_vip

    # vnc 
    if $::novncproxy_base_ip {
        $novncproxy_base_ip = $::novncproxy_base_ip
    } else {
        $novncproxy_base_ip = $nova_vip_ip
    }

    
    #ceph 

    if ! $::env {
        $glance_pool= 'images'
        $cinder_pool= 'volumes'
    } else {
        $glance_pool= [$::env ,"_images"]
        $cinder_pool= [$::env , "_volumes"]
    }

    if $::external_network_id {
        $external_network_id_1 =  $::external_network_id
    }

    if $::use_namespaces {
        $use_namespaces = $::use_namespaces
    } else {
        $use_namespaces = "False"
    }

    if $::enable_lbaas {
        $enable_lbaas = $::enable_lb
    } else {
        $enable_lbaas = True
    }

    if $::enable_l3 {
        $enable_l3 = $::enable_l3
    } else {
        $enable_l3 = True
    }

    if $::enable_dhcp {
        $enable_dhcp = $::enable_dhcp
    } else {
        $enable_dhcp = True
    }

    if $::enable_metadata {
        $enable_metadata = $::enable_metadata
    } else {
        $enable_metadata = True
    }
        
    if $::mode {
        $mode = $::mode
    } else {
        $mode = 'standard'
    }

    $enable_mysql = true
    $enable_rabbitmq = true
    $enable_haproxy = false 

    if $::enable_pacemaker {
        $enable_pacemaker = $::enable_pacemaker
    } else {
        if $mode == 'ha' or 
            $mode == 'ha_all' {
            $enable_pacemaker = true
        } else {
            $enable_pacemaker = false 
        }
    }


    if $::enable_ceph {
        $enable_ceph = $::enable_ceph
    } else {
        $enable_ceph = true 
    }
    
    if $::enable_ceph_fs {
        $enable_ceph_fs = $::enable_ceph_fs
    } else {
        $enable_ceph_fs = false
    }

    $enable_cinder_enabled_backends = false
    
    #global settings 
    $rabbitmq_user = 'guest'
    $rabbitmq_password = 'guest'
    $rabbitmq_port = 5672

    $quantum_tenant = 'service'
    $quantum_user = 'quantum'
    $quantum_password = 'service_pass'

    $glance_user='glance'
    $glance_password='service_pass'
    
    $cinder_user='cinder'
    $cinder_password='service_pass'

    $nova_user='nova'
    $nova_password='service_pass'
    
    $metadata_proxy_shared_secret='helloOpenStack'

    #mysql 
    
    $mysql_server_port=3306

    #keystone db
    $mysql_keystone_user='keystone'
    $mysql_keystone_password='password'
    $mysql_keystone_db='keystone'

    #nova db
    $mysql_nova_user='nova'
    $mysql_nova_password='password'
    $mysql_nova_db='nova'

    #quantum db
    $mysql_quantum_user='quantum'
    $mysql_quantum_password='password'
    $mysql_quantum_db='quantum'

    #glance db
    $mysql_glance_user='glance'
    $mysql_glance_password='password'
    $mysql_glance_db='glance'

    #cinder db
    $mysql_cinder_user='cinder'
    $mysql_cinder_password='password'
    $mysql_cinder_db='cinder' 

    #nova 
    $nova_metadata_port=8775
}
