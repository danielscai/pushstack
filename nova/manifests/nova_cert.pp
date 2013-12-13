class nova::nova_cert {
    include nova::common

    package { "nova-cert" :
        ensure => installed,
    }
    
    realize(File["nova-api-paste.ini"])
    realize(File["nova.conf"])

    service { 'nova-cert' :
        require => Package['nova-cert'],
        ensure => running,
        subscribe => File["/etc/nova/nova.conf","/usr/share/pyshared/nova/network/quantumv2/api.py"];
    }
}
