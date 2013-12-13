class ceph {

    Class["ceph::install"] ->
    Class["ceph::config"] ->
    Class["ceph::service"]
    
    class { "ceph::service": }
    class { "ceph::install": }
    class { "ceph::config": }

}
