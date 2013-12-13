class hosts {
    file {
        "/etc/hosts": owner => root, group => root, mode => 644, ensure => present,
        content => template(
                        'hosts/hosts_default.erb',
                        'hosts/hosts_other.erb',
                        'hosts/hosts_dev.erb',
                        'hosts/hosts_self.erb'
                    )
    }
}
