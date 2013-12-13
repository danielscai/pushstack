class user::root {
    file {
        "/root/.ssh": owner => root, group => root, mode => 700, ensure => directory;
        "/root/.ssh/id_dsa": owner => root, group => root, mode => 600, ensure => present,
        content => template("user/id_rsa.erb"),
        require => File["/root/.ssh"];

        "/root/.ssh/id_rsa": owner => root, group => root, mode => 600, ensure => present,
        content => template("user/id_rsa.erb"),
        require => File["/root/.ssh"];

        "/root/.ssh/authorized_keys": owner => root, group => root, mode => 644, ensure => present,
        content => template("user/authorized_keys.erb"),
        require => File["/root/.ssh"];

        "/root/.ssh/config": owner => root, group => root, mode => 644, ensure => present,
        content => "StrictHostKeyChecking no\n",
        require => File["/root/.ssh"];

        #"/root/.ssh/known_hosts": ensure => absent;
    }
}
