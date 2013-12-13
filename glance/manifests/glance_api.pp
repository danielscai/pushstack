class glance::glance_api (
    ) inherits glance::params {

    package { "glance-api" :
        ensure => installed,
    }

    file {
        "/etc/glance/glance-api.conf":
        ensure => present,
        require => Package['glance-api'],
        content => template("glance/glance-api.conf.erb");

        "/etc/glance/glance-api-paste.ini":
        ensure => present,
        require => Package['glance-registry'],
        content => template("glance/glance-api-paste.ini.erb");
    }

    service {
        "glance-api":
        ensure => running,
        enable => true,
        hasrestart => true,
        hasstatus => true,
        require => Package['glance-api'],
        subscribe => File["/etc/glance/glance-api.conf","/etc/glance/glance-api-paste.ini"];
    }
}
