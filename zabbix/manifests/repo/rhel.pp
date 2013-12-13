class zabbix::repo::rhel {

    yumrepo {'zabbixzone':
      baseurl  => 'http://repo.zabbixzone.com/centos/$releasever/$basearch/',
      descr    => 'Zabbix Packages for Enterprise Linux 6 - $basearch',
      enabled  => '1',
      gpgcheck => '0',
    }

    yumrepo {'zabbixzone-noarch':
      baseurl  => 'http://repo.zabbixzone.com/centos/$releasever/noarch/',
      descr    => 'Zabbix Packages for Enterprise Linux 6 - $basearch',
      enabled  => '1',
      gpgcheck => '0',
    }
}
