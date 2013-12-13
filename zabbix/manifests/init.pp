#
class zabbix inherits zabbix::params {
    case $::osfamily {
        'RedHat', 'SUSE': {
            include '::zabbix::repo::rhel'
        }
        'Debian': {
            include '::zabbix::repo::apt'
        }
        default: {
        }
    }
}


