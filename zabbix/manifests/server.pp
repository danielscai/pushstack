class zabbix::server inherits zabbix {
    case $operatingsystem {
        CentOS: {
            include zabbix::server::centos
        }

        Ubuntu: {
            include zabbix::server::ubuntu
        }

        default: {
            notify { "Error: $operatingsystem is not exist for \"$title\"": }
        }
    } 
}
