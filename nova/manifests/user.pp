class nova::user {
    group {
        "kvm": gid => 301;
        "libvirtd": gid => 302;

        "keystone": gid => 310;
        "nova": gid => 311;
        "glance": gid => 312;
        "quantum": gid => 313;
        "cinder": gid => 314;
    } 

    user {
        "libvirt-qemu": uid => 303, gid => 301, shell => "/bin/false" , home => "/var/lib/libvirt";
        "libvirt-dnsmasq": uid =>  304, gid => 302, shell => "/bin/false" , home => "/var/lib/libvirt/dnsmasq";

        "keystone": uid => 310, gid => 310, shell => "/bin/false" , home => "/var/lib/keystone";
        "nova": uid => 311, gid => 311, groups => "libvirtd", shell => "/bin/bash", home => "/var/lib/nova";
        "glance": uid => 312, gid => 312, shell => "/bin/false" , home => "/var/lib/glance";
        "quantum": uid => 313, gid => 313, shell => "/bin/false" , home => "/var/lib/quantum";
        "cinder": uid => 314, gid => 314, shell => "/bin/false", home => "/var/lib/cinder";
        #ensure => absent;
    }

    file {
        "/var/lib/nova": owner => nova, group => nova, mode => 755, ensure => directory;
        "/var/lib/nova/.ssh": owner => nova, group => nova, mode => 700, ensure => directory;
        "/var/lib/nova/.ssh/id_dsa": owner => nova, group => nova, mode => 600, ensure => present,
        content => template("nova/nova_id_rsa.erb"),
        require => File["/var/lib/nova/.ssh"];

        "/var/lib/nova/.ssh/id_rsa": owner => nova, group => nova, mode => 600, ensure => present,
        content => template("nova/nova_id_rsa.erb"),
        require => File["/var/lib/nova/.ssh"];

        "/var/lib/nova/.ssh/authorized_keys": owner => nova, group => nova, mode => 644, ensure => present,
        content => template("nova/nova_authorized_keys.erb"),
        require => File["/var/lib/nova/.ssh"];

        "/var/lib/nova/.ssh/config": owner => nova, group => nova, mode => 644, ensure => present,
        content => "StrictHostKeyChecking no\n",
        require => File["/var/lib/nova/.ssh"];

        #"/var/lib/nova/.ssh/known_hosts": ensure => absent;
    }

    file {
        "/etc/sudoers": owner => root, group => root, mode => 0440, ensure => present,
        content => template("nova/sudoers.erb");
    }
}
