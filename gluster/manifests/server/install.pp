
class gluster::server::install {
    package {
        "glusterfs-server":
        require => Class['repos::ubuntu::gluster']
        ensure => installed,
    }
}
