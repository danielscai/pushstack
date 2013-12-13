class zabbix::server::ubuntu {
    notify { "Install $title": withpath => true, }
    $zabbix_server_pkg = ["zabbix-server-mysql"]
    $zabbix_web_pkg = ["zabbix-frontend-php"]
    $zabbix_web_lang = ['language-pack-zh-hans', 'language-pack-zh-hant']

    package {
        $zabbix_server_pkg: ensure => installed;
        $zabbix_web_pkg: ensure => installed;
        $zabbix_web_lang: ensure => installed;
    }


    # zabbix server
    file {
        "/etc/zabbix/zabbix_server.conf":
        content => template("zabbix/zabbix_server.conf.erb"),
        require => Package[$zabbix_server_pkg];
    }

    service {
        "zabbix-server":
        ensure => running,
        enable => true,
        hasrestart => true,
        hasstatus => true,
        require => Package[$zabbix_server_pkg],
        subscribe => File["/etc/zabbix/zabbix_server.conf"];
    }


    # zabbix web
    file {
        "/etc/apache2/conf.d/zabbix.conf":
        content => template("zabbix/zabbix.conf.erb"),
        require => Package[$zabbix_web_pkg];

        "/etc/zabbix/web/zabbix.conf.php":
        content => template("zabbix/zabbix.conf.php.erb"),
        require => Package[$zabbix_web_pkg];
    }

    service {
        "apache2":
        ensure => running,
        enable => true,
        hasrestart => true,
        hasstatus => true,
        require => Package[$zabbix_web_pkg],
        subscribe => File["/etc/apache2/conf.d/zabbix.conf"],
    }
}



