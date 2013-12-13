
class nova::kvm {
    #$kvm_pkg = ["vlan", "bridge-utils", "cpu-checker", "libvirt-bin", "pm-utils", "kvm","kvm-ipxe"]
    $kvm_pkg = ["vlan", "cpu-checker", "libvirt-bin", "pm-utils", "kvm","kvm-ipxe"]

    File {
        owner => root,
        group => root,
        mode => 644,
    }

    # KVM
    package { 
        $kvm_pkg:
        ensure => installed,
    }

    Class['nova::user'] -> Package[$kvm_pkg]

    file {
        "/etc/libvirt/qemu.conf":
        owner => root,
        group => root,
        mode => 644,
        ensure => present,
        require => Package[$kvm_pkg],
        notify  => Exec["kvm_virsh"],
        content => template("nova/qemu.conf.erb"),
    }

    exec {
        "kvm_virsh":
        command => "/usr/bin/virsh net-destroy default; /usr/bin/virsh net-undefine default;",
        unless => "/usr/bin/virsh net-list | grep default",
        require => Package[$kvm_pkg],
        refreshonly => true,
    }

    file {
        "/etc/libvirt/libvirtd.conf": 
        require => File["/etc/libvirt/qemu.conf"],
        content => template("nova/libvirtd.conf.erb");

        "/etc/default/libvirt-bin": 
        require => File["/etc/libvirt/qemu.conf"],
        content => template("nova/libvirt-bin.conf.erb");
    }

    service {
        "libvirt-bin":
        ensure => running,
        enable => true,
        hasrestart => true,
        hasstatus => true,
        require => Package[$kvm_pkg],
        subscribe => File["/etc/libvirt/libvirtd.conf", "/etc/libvirt/qemu.conf", "/etc/default/libvirt-bin"];
    }
}

