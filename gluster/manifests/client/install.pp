
class gluster::client::install {
    package {
        "glusterfs-client":
        require => Class['repos::ubuntu::gluster']
        ensure => installed,
    }
}
