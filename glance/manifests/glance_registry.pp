class glance::glance_registry {
    package { "glance-registry" :
        ensure => installed,
    }

    file {
        "/etc/glance/glance-registry.conf":
        ensure => present,
        owner => glance,
        group => glance,
        mode => 0644,
        require => Package['glance-registry'],
        content => template("glance/glance-registry.conf.erb");

        "/etc/glance/glance-registry-paste.ini":
        ensure => present,
        owner => glance,
        group => glance,
        mode => 0644,
        require => Package['glance-registry'],
        content => template("glance/glance-registry-paste.ini.erb");
    }

    service {
        "glance-registry":
        ensure => running,
        enable => true,
        hasrestart => true,
        hasstatus => true,
        require => Package['glance-registry'],
        subscribe => File["/etc/glance/glance-registry.conf","/etc/glance/glance-registry-paste.ini"];
    }
}
