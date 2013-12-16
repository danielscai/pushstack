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

    package {
        $ceph_pkg:
        ensure => $ceph_client_set,
    }

    Class['ceph::repo'] -> Class['ceph::client']
}
