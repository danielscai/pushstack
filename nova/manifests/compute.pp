
class nova::compute (
    $network_bridge = $nova::params::network_bridge,
    $libvirt_vif_driver_linuxbridge = $nova::params::libvirt_vif_driver_linuxbridge,
    $linuxnet_interface_driver_linuxbridge = $nova::params::linuxnet_interface_driver_linuxbridge,
    $libvirt_vif_driver_ovs = $nova::params::libvirt_vif_driver_ovs,
    ) inherits nova::params {

    include nova::common
    include nova::kvm
    include nova::python_nova
    include nova::user

    # Nova
    $nova_pkg = ["nova-compute-kvm"]

    #if $network_bridge == "linuxbridge" {
    #   $libvirt_vif_driver = $libvirt_vif_driver_linuxbridge
    #   $linuxnet_interface_driver = $linuxnet_interface_driver_linuxbridge
    #} elsif $network_bridge == "ovs" {
    #   $libvirt_vif_driver = $libvirt_vif_driver_ovs
    #} 

    package { 
        $nova_pkg:
        ensure => installed,
        require => User["nova"];
    }
    package { 'qemu-kvm-spice': ensure => absent }

    Class['nova::user'] -> Package[$nova_pkg]

    realize(File["nova-api-paste.ini"])
    realize(File["nova.conf"])

    file {
        "/etc/nova/nova-compute.conf": 
        ensure => present,
        require => Package[$nova_pkg],
        content => template("$module_name/nova-compute.conf.erb");
    }

    service {
        "nova-compute":
        ensure => running,
        enable => true,
        hasrestart => true,
        hasstatus => true,
        require => Package[$nova_pkg],
        subscribe => File["/etc/nova/nova-compute.conf", "/etc/nova/nova.conf",
                "/usr/share/pyshared/nova/network/quantumv2/api.py"],
    }
}
