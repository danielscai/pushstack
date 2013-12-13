
class neutron::common (
    $use_namespaces  = $neutron::params::use_namespaces,
    $plugin_ini = $neutron::params::plugin_ini,
    $core_plugin = $neutron::params::core_plugin,
    ) inherits neutron::params {

    $quantum_common_pkg=['quantum-common']

    File {
        owner => root,
        group => root,
        mode => 644,
    }

    package { 
        $quantum_common_pkg:
        ensure => installed,
        #provider => apt,
    }
    

    file {
        "/etc/quantum/quantum.conf":
        ensure => present,
        require => [Package[$quantum_common_pkg]],
        content => template("neutron/quantum.conf.erb");
    }

}
