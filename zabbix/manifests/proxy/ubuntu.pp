class zabbix::proxy::ubuntu {
    notify { "Install $title": withpath => true, }
    $zabbix_proxy_pkg = ["zabbix-proxy-mysql"]

    package {
        $zabbix_proxy_pkg: ensure => installed;
    }


    # zabbix server
    file {
        "/etc/zabbix/zabbix_proxy.conf":
        content => template("zabbix/zabbix_proxy.conf.erb"),
        require => Package[$zabbix_proxy_pkg];
    }

    service {
        "zabbix-proxy":
        ensure => running,
        enable => true,
        hasrestart => true,
        hasstatus => true,
        require => Package[$zabbix_proxy_pkg],
        subscribe => File["/etc/zabbix/zabbix_proxy.conf"];
    }
}
