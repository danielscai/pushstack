class oshotfix::network_interface_attach (
    ) inherits oshotfix::params {
    include nova::python_nova

    file { "/usr/share/pyshared/nova/virt/libvirt/driver.py":
        content => template("oshotfix/nova_libvirt_driver.py.erb"),
        require => Package['python-nova'],
    }

}
