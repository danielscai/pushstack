class ceph::client (
    $enable = true,
    ) inherits ceph::params {

    include ceph::repo    

    if $enable {
        $ceph_client_set = 'installed'
        include ceph::config
    } else {
        $ceph_client_set = 'purged'
    }

    $ceph_pkg = ['python-ceph','ceph-common']

    file { '/etc/apt/sources.list.d/ceph.list': 
        ensure => present,
        content => "deb http://ceph.com/debian-dumpling/ precise main",
    }
     
    #exec { "apt-update":
    #    command => "/usr/bin/apt-get update",
    #}
   
    package {
        $ceph_pkg:
        ensure => $ceph_client_set,
    }

    #File['/etc/apt/sources.list.d/ceph.list'] -> 
    #Exec['apt-update'] ->
    #Package[$ceph_pkg]
    Class['ceph::repo'] -> Class['ceph::client']
}
