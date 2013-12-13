class zabbix::repo::apt {

    #Class['zabbix::repo::apt'] -> Class['']
    apt::source { 'zabbix':
        location    => 'http://repo.zabbix.com/zabbix/2.0/ubuntu',
        release     => 'precise',
        repos       => 'main',
        include_src => false,
        key         => '79EA5ED4',
        key_content => template('zabbix/zabbix.pub.key.erb'),
    }
}
