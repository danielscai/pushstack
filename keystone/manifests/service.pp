class keystone::service {
    $keystone_pkg = ["keystone", "python-keystone", "python-keystoneclient"]

    package { 
        $keystone_pkg:
        ensure => installed,
    }

    file {
        "/etc/keystone/keystone.conf":
        ensure => present,
        require => Package[$keystone_pkg],
        content => template("$module_name/keystone.conf.erb");
    } 

    service {
        "keystone":
        ensure => running,
        enable => true,
        hasrestart => true,
        hasstatus => true,
        require => Package[$keystone_pkg],
        subscribe => File["/etc/keystone/keystone.conf"];
    }
}
