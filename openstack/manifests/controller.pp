class openstack::controller (
    $mode = $openstack::params::mode,
    $openstack_host = $openstack::params::openstack_host,
    $enable_mysql = $openstack::params::enable_mysql,
    $enable_rabbitmq = $openstack::params::enable_rabbitmq,
    $enable_haproxy = $openstack::params::enable_haproxy,
    $enable_pacemaker = $openstack::params::enable_pacemaker,
    $enable_cinder_enabled_backends = $openstack::params::enable_cinder_enabled_backends,
    $network_type = $openstack::params::network_type,
    $network_bridge = $openstack::params::network_bridge,
    $mysql_bind_ip = $openstack::params::mysql_bind_ip,
    $rabbitmq_bind_ip = $openstack::params::rabbitmq_bind_ip,
    $apache_bind_ip = $openstack::params::apache_bind_ip,
    $enable_hotfix = $openstack::params::enable_hotfix,

    #ceph
    $enable_ceph = $openstack::params::enable_ceph,
    $enable_ceph_fs = $openstack::params::enable_ceph_fs,


    ) inherits openstack::params  {

    #if $network_bridge != 'linuxbridge' or
    #   $network_bridge != 'ovs' or 
    #   $network_bridge != 'flat' {
    #    fail(" Network bridge $network_bridge not supported , 
    #            supported network bridge are 'linuxbridge','ovs','flat')
    #}

        
    if $enable_ceph {
        include ceph::client
    }

    if $enable_hotfix {
        include oshotfix
    }
    
    include provision
    include osinit::env
    # uid controll class 
    class {'nova::user': } 

    # repo dependency 
    class {'openstack::repo': }

    #Class['openstack::repo'] ->
    #Class['openstack::controller']



    # openstack standard components
    class {'keystone': 
        enable_utils => true
    }
    class {'nova': }
    class {'neutron::server': }
    class {'glance': }
    class {'cinder': } 
    class {'horizon::service': 
        openstack_host => $openstack::controller::openstack_host,
        apache_bind_ip => $openstack::controller::apache_bind_ip,
    }
    
    if $enable_mysql or $mode == 'ha_all' 
        or $mode == 'standard' {
        class {'mysql': 
            mysql_bind_ip => $mysql_bind_ip,
        } 
    }
    
    if $enable_rabbitmq  
        or $mode == 'ha_all'
        or $mode == 'standard' {

        class {'rabbitmq': 
            rabbitmq_listen_ip => $rabbitmq_bind_ip,
        }
    }

    if $enable_haproxy 
        or $mode == 'ha' 
        or $mode == 'ha_all'  {

        class { "haproxy":
            template => "openstack/haproxy_openstack.cfg.erb",
        }
    }
    
    if $enable_cinder_enabled_backends {
        $cinder_multi_storage = $openstack::params::cinder_enabled_backends
    }

    if $enable_pacemaker{


        class {"pacemaker::corosync":
            cluster_name => "cluster_name",
            cluster_members => "192.168.122.3 192.168.122.7",
        }

        class {"pacemaker::stonith":
            disable => true,
        }

        class {"pacemaker::resource::ip":
            ip_address => $vip,
        }
    }
} 
