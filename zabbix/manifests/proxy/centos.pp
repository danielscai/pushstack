class zabbix::proxy::centos {
    notify { "Install $title": withpath => true, }
    $zabbix_proxy_pkg = ["zabbix-proxy-mysql"]
    #$zabbix_web_pkg = ["zabbix-web-mysql"]

    package {
        $zabbix_proxy_pkg: ensure => installed;
        #$zabbix_web_pkg: ensure => installed;
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


    # zabbix web
    #file {
    #    "/etc/httpd/conf.d/zabbix.conf":
    #    content => template("zabbix/zabbix.conf.erb"),
    #    require => Package[$zabbix_web_pkg];

    #    "/etc/zabbix/web/zabbix.conf.php":
    #    content => template("zabbix/zabbix.conf.php.erb"),
    #    require => Package[$zabbix_web_pkg];
    #}

    #service {
    #    "httpd":
    #    ensure => running,
    #    enable => true,
    #    hasrestart => true,
    #    hasstatus => true,
    #    require => Package[$zabbix_web_pkg],
    #    subscribe => File["/etc/httpd/conf.d/zabbix.conf"],
    #}
}



