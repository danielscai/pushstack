class provision::sysctl_set {
    sysctl { 'net.ipv4.ip_forward': value => '1' }
    sysctl {'net.ipv4.conf.default.rp_filter': value => '1' }
    sysctl {'net.ipv4.conf.default.accept_source_route': value => '0' }
    sysctl {'kernel.sysrq': value => '0' }
    sysctl {'kernel.core_uses_pid': value => '1' }
    sysctl {'net.ipv4.tcp_syncookies': value => '1' }
    sysctl {'kernel.msgmnb': value => '65536' }
    sysctl {'kernel.msgmax': value => '65536' }
    sysctl {'kernel.shmmax': value => '68719476736' }
    sysctl {'kernel.shmall': value => '4294967296' }
    sysctl {'kernel.core_pattern': value => '/var/log/coredump/core.%e.%p.%h.%t' }
    sysctl {'net.ipv4.ip_nonlocal_bind': value => '1' }
    kmod::load {'nf_conntrack': } ->
    sysctl {'net.nf_conntrack_max': value => '1048576' }
    #Class['nf_conntrack'] -> Class['net.nf_conntrack_max']
}
