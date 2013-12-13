class zabbix::agent::centos inherits zabbix::agent {
    $zabbix_agent_pkg = ["zabbix-agent"]

    package { $zabbix_agent_pkg:
        ensure => latest,
	# ensure => [$zabbix_version, $package_ensure]
    }

    notify { "Install $title": withpath => true, }
    file {
        "/etc/zabbix/zabbix_agentd.conf":
        content => template("zabbix/zabbix_agentd.conf.erb"),
        require => Package[$zabbix_agent_pkg];

        "/etc/zabbix/zabbix_custom.d":
        ensure => "directory";

        "/etc/zabbix/zabbix_agentd.d":
        recurse => true, purge => true, force => true,
        source => "puppet://$fileserver/zabbix/zabbix_agentd.d";
    }

    service {
        "zabbix-agent":
        ensure => running,
        enable => true,
        hasrestart => true,
        hasstatus => true,
        require => Package[$zabbix_agent_pkg],
        subscribe => File["/etc/zabbix/zabbix_agentd.conf","/etc/zabbix/zabbix_agentd.d"],
    }
}
