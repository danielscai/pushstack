class zabbix::proxy inherits zabbix {
    case $operatingsystem {
        CentOS: {
            include zabbix::proxy::centos
        }

        Ubuntu: {
            include zabbix::proxy::ubuntu
        }

        default: {
            notify { "Error: $operatingsystem is not exist for \"$title\"": }
        }
    } 
}
