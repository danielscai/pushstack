class neutron::agent::lbaas (
    $network_bridge,
    $use_namespaces  = $neutron::params::use_namespaces,
    ) inherits neutron::params {

    include openstack::params
    include neutron::common
    include haproxy 

    $quantum_lbaas_agent_pkg = ['quantum-lbaas-agent',]

    $lb_driver =  $network_bridge ? {
        'linuxbridge' => $neutron::params::linuxbridge_driver,
        'ovs' => $neutron::params::openvswitch_driver,
        default => $neutron::params::linuxbridge_driver,
    }

    package { 
        [$quantum_lbaas_agent_pkg]:
        ensure => installed,
        #provider => apt,
    }

    file {
        "/etc/quantum/lbaas_agent.ini":
        ensure => present,
        require => Package[$quantum_lbaas_agent_pkg],
        content => template("neutron/lbaas_agent.ini.erb");

        ["/etc/quantum/plugins", "/etc/quantum/plugins/services", "/etc/quantum/plugins/services/agent_loadbalancer"]:
        owner => root, group => quantum, mode => 755,
        ensure => directory;

        "/etc/quantum/plugins/services/agent_loadbalancer/lbaas_agent.ini":
        owner => root, group => quantum, mode => 644,
        ensure => present,
        require => File["/etc/quantum/plugins/services/agent_loadbalancer"],
        content => template("neutron/lbaas_agent.ini.erb");
    }

    service {
        ["quantum-lbaas-agent"]:
        ensure => running,
        enable => true,
        hasrestart => true,
        hasstatus => true,
        require => Package[$quantum_lbaas_agent_pkg],
        subscribe => File["/etc/quantum/lbaas_agent.ini"]
    }

    Class['neutron::server'] -> Class['neutron::agent::lbaas']

}
