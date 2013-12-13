class openstack::compute (
    $enable_ceph = $openstack::params::enable_ceph,
    $enable_ceph_fs = $openstack::params::enable_ceph_fs,
    $network_bridge = $openstack::params::network_bridge,
    ) inherits openstack::params {

    if $enable_ceph {
        include ceph::client
    }

    class {'ceph::fs':
        enable => $enable_ceph_fs 
    }
    
    include provision
    include openstack::repo
    Class['openstack::repo'] -> Class['openstack::compute']

    class {'nova::compute': 
        network_bridge => $network_bridge,
    }

    if $network_bridge == "linuxbridge" {
        include neutron::agent::linuxbridge
    } elsif $network_bridge == "ovs" {
        include neutron::agent::ovs
    }

    class {'provision::rc_local':
        rc_local => $::rc_local
    }

}
