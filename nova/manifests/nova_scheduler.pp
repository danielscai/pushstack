class nova::nova_scheduler {
    include nova::common

    package { "nova-scheduler" :
        ensure => installed,
    }
    
    realize(File["nova-api-paste.ini"])
    realize(File["nova.conf"])

    service { 'nova-scheduler' :
        require => Package['nova-scheduler'],
        ensure => running,
        subscribe => File["/etc/nova/nova.conf","/usr/share/pyshared/nova/network/quantumv2/api.py"];
    }
}
