class nova::nova_api {
    include nova::common
    
    package { "nova-api" :
        ensure => installed,
    }
    
    realize(File["nova-api-paste.ini"])
    realize(File["nova.conf"])

    service { 'nova-api' :
        require => Package['nova-api'],
        ensure => running,
        subscribe => File["/etc/nova/nova.conf","/usr/share/pyshared/nova/network/quantumv2/api.py"];
    }
}
