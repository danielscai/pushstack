class zabbix::agent::windows {

    $zabbix_dir='c:\zabbix'
    $arch_num=regsubst($architecture, "[^0-9]*([0-9]+)", "\1")    
    $zbx_servicename="Zabbix Agent"

    file {
        "$zabbix_dir":
        source => "puppet://$fileserver/zabbix/zabbix_win",
        notify => Exec["zabbix_install"],
        recurse => true, purge => true, force => true;

        "$zabbix_dir\\zabbix-agent.bat":
        content => template("$module_name/zabbix-agent.bat.erb");

        'c:\zabbix\conf\zabbix_agentd.win.conf':
        content => template("$module_name/zabbix_agentd.conf.erb");
    }

    exec { "zabbix_install":
        command => "$zabbix_dir\\bin\\win$arch_num\\zabbix_agentd.exe -c $zabbix_dir\\conf\\zabbix_agentd.win.conf -i",
        unless => "C:\\Windows\\System32\\sc.exe qc \"$zbx_servicename\"",
        refreshonly => true;
    }

    service {
        "$zbx_servicename":
        ensure => running,
        enable => true,
        subscribe => File["$zabbix_dir",'c:\zabbix\conf\zabbix_agentd.win.conf'],
        provider => windows
    }
}
