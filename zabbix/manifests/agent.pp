class zabbix::agent {
    case $operatingsystem {
        CentOS: {
            include zabbix::agent::centos
        }

        Ubuntu: {
            include zabbix::agent::ubuntu
        }
        
        windows: {
            include zabbix::agent::windows
        }

        default: {
            notify { "Error: $operatingsystem is not exist for \"$title\"": }
        }
    } 
}
