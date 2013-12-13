class nova::nova_novncproxy {
    include nova::common    

    package { "nova-novncproxy" :
        ensure => installed,
    }
    
    realize(File["nova-api-paste.ini"])
    realize(File["nova.conf"])

    service { 'nova-novncproxy' :
        require => Package['nova-novncproxy'],
        ensure => running,
        subscribe => File["/etc/nova/nova.conf","/usr/share/pyshared/nova/network/quantumv2/api.py"];
    }
}
