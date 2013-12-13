class neutron::agent::l3 (
    $network_bridge,
    $use_namespaces  = $neutron::params::use_namespaces_l3,
    $external_network_bridge = $neutron::params::external_network_bridge,
    $enable_l3 = true,
    ) inherits neutron::params {
    
    include openstack::params
       
    $l3_driver =  $network_bridge ? {
        'linuxbridge' => $neutron::params::linuxbridge_driver,
        'ovs' => $neutron::params::openvswitch_driver,
        default => $neutron::params::linuxbridge_driver,
    }

    include neutron::common
    $quantum_pkg = ['quantum-l3-agent']

    $pkg_enabled = $enable_l3 ? {
        false   => absent,
        default => installed
    }
    
    $file_enabled = $enable_l3 ? {
        false   => absent,
        default => present
    }

    package { 
        [$quantum_pkg]:
        ensure => $pkg_enabled,
    }
    

    file {
        "/etc/quantum/l3_agent.ini":
        ensure => $file_enabled,
        require => Package[$quantum_pkg],
        content => template("neutron/l3_agent.ini.erb");
    }

    # should a if statment
    #exec {
    #    "ovs_vsctl_l3":
    #    command => $network_type ? {
    #        gre => "/usr/bin/ovs-vsctl add-br br-ex && /usr/bin/ovs-vsctl add-port br-ex $external_network_device",
    #        vlan => "/usr/bin/ovs-vsctl add-br br-int; /usr/bin/ovs-vsctl add-br br-eth1; /usr/bin/ovs-vsctl add-port br-eth1 eth1;",
    #        default => "/usr/bin/ovs-vsctl add-br br-ex;",
    #    },
    #    unless => $network_type ? {
    #        gre => "/sbin/ip add | /bin/egrep -q 'br-ex' && /sbin/lsmod | /bin/egrep -q openvswitch",
    #        vlan => "/sbin/ip add | /bin/egrep -q 'br-int' && /sbin/ip add | /bin/egrep -q ' br-eth1'",
    #        default => "/sbin/ip add | /bin/egrep -q 'br-int'",
    #    },
    #    require => Exec[ovs_loadmod],
    #    #require => Package[$ovs_pkg],
    #    #refreshonly => true,
    #}

    if $enable_l3 {
        service {
            ["quantum-l3-agent"]:
            ensure => running,
            enable => true,
            hasrestart => true,
            hasstatus => true,
            require => Package[$quantum_pkg],
            subscribe => File["/etc/quantum/quantum.conf", "/etc/quantum/l3_agent.ini"];
        }
    }

    Class['neutron::server'] -> Class['neutron::agent::l3']

}

