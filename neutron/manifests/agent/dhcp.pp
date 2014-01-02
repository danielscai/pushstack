class neutron::agent::dhcp (
    $network_bridge,
    $use_namespaces  = $neutron::params::use_namespaces,
    $dhcp_domain = 'local',
    ) inherits neutron::params {

    include openstack::params
    include neutron::server
    
    $dhcp_driver =  $network_bridge ? {
        'linuxbridge' => $neutron::params::linuxbridge_driver,
        'ovs' => $neutron::params::openvswitch_driver,
        default => $neutron::params::linuxbridge_driver,
    }

    include neutron::common
    $quantum_pkg = ['quantum-dhcp-agent']


    package { 
        [$quantum_pkg]:
        ensure => installed,
        #provider => apt,
    }

    file {
        "/etc/quantum/dhcp_agent.ini":
        ensure => present,
        require => Package[$quantum_pkg],
        content => template("neutron/dhcp_agent.ini.erb");
    }

    service {
        ["quantum-dhcp-agent"]:
        ensure => running,
        enable => true,
        hasrestart => true,
        hasstatus => true,
        require => Package[$quantum_pkg],
        subscribe => File["/etc/quantum/quantum.conf","/etc/quantum/dhcp_agent.ini"];
    }

    Class['neutron::server'] -> Class['neutron::agent::dhcp']

}

