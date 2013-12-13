class mysql::service (
    $mysql_bind_ip ,
    ) {
    $mysql_pkg=['mysql-server','mysql-server-5.5','mysql-server-core-5.5','mysql-common']

    File {
        owner => root,
        group => root,
        mode => 644,
    }

    package { 
        $mysql_pkg:
        ensure => installed,
        #provider => apt,
    }
    
    file {
        "/etc/mysql/my.cnf":
        ensure => present,
        require => [Package[$mysql_pkg]],
        content => template("mysql/my.cnf.erb");
    }

    service {
        ["mysql"]:
        require => Package[$mysql_pkg],
        ensure => running,
        subscribe => File["/etc/mysql/my.cnf"];
    }
}
