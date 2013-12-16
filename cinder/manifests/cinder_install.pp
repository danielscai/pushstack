class cinder::cinder_install (
    $enabled_backends = false,
    ) inherits cinder::params {

    include openstack::params
    include nova::user

    include cinder::cinder_api
    include cinder::cinder_scheduler
    include cinder::cinder_volume
    include cinder::python_cinderclient
 
    file {
            "/etc/cinder/cinder.conf":
            ensure => present,
            require => Class["cinder::cinder_api", "cinder::cinder_scheduler", "cinder::cinder_volume"],
            content => template("cinder/cinder.conf.erb");
    
            "/etc/cinder/api-paste.ini":
            ensure => present,
            require => Class["cinder::cinder_api", "cinder::cinder_scheduler", "cinder::cinder_volume"],
            content => template("cinder/cinder-api-paste.ini.erb");
    }
    
    service {
            ["cinder-api", "cinder-scheduler", "cinder-volume"]:
            ensure => running,
            enable => true,
            hasrestart => true,
            hasstatus => true,
            require => File["/etc/cinder/cinder.conf"],
            subscribe => File["/etc/cinder/cinder.conf", "/etc/cinder/api-paste.ini"];
    }

    Class['nova::user'] -> Package<||>
}
