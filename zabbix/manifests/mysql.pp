class zabbix::mysql {
    case $operatingsystem {
        CentOS: {
            include zabbix::mysql::centos
        }

        Ubuntu: {
            include zabbix::mysql::ubuntu
            #notify { "Error: $operatingsystem is not exist for \"$title\"": }
        }

        default: {
            notify { "Error: $operatingsystem is not exist for \"$title\"": }
        }
    } 
}
