class ceph::config (
    ) inherits ceph::params {

    file {'ceph_dir':
        path => "/etc/ceph",
        ensure => directory;
    }

    file {'ceph.conf':
        path => "/etc/ceph/ceph.conf",
        ensure => present,
        content => template("ceph/ceph.conf.erb");
    }
}
