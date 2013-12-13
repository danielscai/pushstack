class neutron::server (
    $enable_namespace = $neutron::params::enable_namespace,
    $plugin_ini = $neutron::params::plugin_ini,
    $core_plugin = $neutron::params::core_plugin,
    ) inherits neutron::params {

    include openstack::params
    include neutron::common
    include neutron::utils

    $quantum_pkg = ["quantum-server"]

    File {
        owner => root,
        group => root,
        mode => 644,
    }

    package { 
        $quantum_pkg:
        ensure => installed,
        #provider => apt,
    }

    file {
        "/etc/quantum/api-paste.ini":
        ensure => present,
        require => Package[$quantum_pkg],
        content => template("neutron/quantum-api-paste.ini.erb");
    
        "/etc/default/quantum-server": 
        ensure => present,
        require => Package[$quantum_pkg],
        content => template("neutron/default-quantum-server.erb");
        
    }

    service {
        ["quantum-server"]:
        ensure => running,
        enable => true,
        hasrestart => true,
        hasstatus => true,
        require => Package[$quantum_pkg],
        subscribe => File["/etc/quantum/quantum.conf", "/etc/quantum/api-paste.ini" ];
    }
}
