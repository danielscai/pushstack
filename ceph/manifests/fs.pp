class ceph::fs (
    $enable = true,
    ) inherits ceph::params {

    if $enable {
        $ceph_fs_set = 'installed'
        include ceph::config
    } else {
        $ceph_fs_set = 'purged'
    }

    $ceph_fs_pkg = ['ceph-fs-common']

    package { 
        $ceph_fs_pkg:
        ensure => $ceph_fs_set,
    }

}
