class provision::rc_local (
    $rc_local,
    ) inherits provision::params {
    
    file{"/etc/rc.local":
        ensure => present,
        content => template("$module_name/rc.local.erb")
    }
}
