class openstack::all (
    ) inherits openstack::params {
    class {'openstack::controller': }
    class {'openstack::network': }
    class {'openstack::compute': }
}


