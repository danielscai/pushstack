class ceph::config (
    ) inherits ceph::params {

    file {'ceph_dir':
        path => "/etc/ceph",
        ensure => directory;
    }

    file {'ceph.conf':
        path => "/etc/ceph/ceph.conf",
        owner => root,
        group => root,
        mode => 0644,
        ensure => present,
        content => template("ceph/ceph.conf.erb");
    }
}
