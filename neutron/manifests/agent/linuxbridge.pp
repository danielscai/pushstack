class neutron::agent::linuxbridge (
    $use_namespaces  = $neutron::params::use_namespaces,
    $network_vlan_ranges = $neutron::params::network_vlan_ranges,
    $physical_interface_mappings = $neutron::params::physical_interface_mappings,
    ) inherits neutron::params {

    include openstack::params    

    include neutron::common
    $linuxbridge_pkg = ["quantum-plugin-linuxbridge", 
                "quantum-plugin-linuxbridge-agent" , "python-mysqldb"]

    
    package { 
        $linuxbridge_pkg:
        ensure => installed,
    }

    # Quantum
    file {
        "/etc/quantum/plugins/linuxbridge/linuxbridge_conf.ini": 
        ensure => present,
        require => Package[$linuxbridge_pkg],
        content => template("neutron/linuxbridge_conf.ini.erb"),
        notify => Service['quantum-plugin-linuxbridge-agent'],
    }

    service {
        "quantum-plugin-linuxbridge-agent":
        ensure => running,
        enable => true,
        hasrestart => true,
        hasstatus => true,
        require => Package[$linuxbridge_pkg],
        subscribe => File["/etc/quantum/plugins/linuxbridge/linuxbridge_conf.ini"],
    }

}
