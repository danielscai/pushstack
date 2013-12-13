class zabbix::mysql::ubuntu {
    notify { "Install $title": withpath => true, }

    $zabbix_db_pkg = ["mysql-server"]

    package {
        $zabbix_db_pkg: ensure => installed;
    }


    # zabbix mysql
    file {
        "/etc/mysql/my.cnf":
        #replace => "no",
        content => template("zabbix/ubuntu_my.cnf.erb"),
        require => Package[$zabbix_db_pkg];
    }

    file {
        "/root/sh":
        ensure => directory;

        "/root/sh/init_zabbix-mysql.sh":
        content => template("zabbix/init_zabbix-mysql.sh.erb"),
        require => Package[$zabbix_db_pkg];

        "/root/sh/schema.sql":
        content => template("zabbix/schema.sql");

        "/root/sh/images.sql":
        content => template("zabbix/images.sql");

        "/root/sh/data.sql":
        content => template("zabbix/data.sql");
    }
        
    exec {
        "init_zabbix-mysql":
        command => "/bin/bash /root/sh/init_zabbix-mysql.sh",
        #unless => "/bin/ls -d /var/lib/mysql/zabbix >/dev/null 2>&1",
        require => File["/root/sh/init_zabbix-mysql.sh"],
        #refreshonly => true;
    }

    service {
        "mysql":
        ensure => running,
        enable => true,
        hasrestart => true,
        hasstatus => true,
        require => Package[$zabbix_db_pkg],
        subscribe => File["/etc/mysql/my.cnf"];
    }
}

