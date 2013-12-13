class nova::nova_consoleauth {
    include nova::common    

    package { "nova-consoleauth" :
        ensure => installed,
    }
    
    realize(File["nova-api-paste.ini"])
    realize(File["nova.conf"])

    service { 'nova-consoleauth' :
        require => Package['nova-consoleauth'],
        ensure => running,
        subscribe => File["/etc/nova/nova.conf","/usr/share/pyshared/nova/network/quantumv2/api.py"];
    }
}
