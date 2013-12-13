class neutron::agent::metadata (
    $use_namespaces  = $neutron::params::use_namespaces
    ) inherits neutron::params {
    include neutron::common
    $quantum_pkg = ['quantum-metadata-agent']

    include openstack::params
    
    package {
        [$quantum_pkg]:
        ensure => installed,
        #provider => apt,
    }

    file {
        "/etc/quantum/metadata_agent.ini":
        ensure => present,
        require => Package[$quantum_pkg],
        content => template("neutron/metadata_agent.ini.erb");
    }

    service {
        ["quantum-metadata-agent"]:
        ensure => running,
        enable => true,
        hasrestart => true,
        hasstatus => true,
        require => Package[$quantum_pkg],
        subscribe => File["/etc/quantum/metadata_agent.ini"];
    }

    Class['neutron::server'] -> Class['neutron::agent::metadata']
      
}
