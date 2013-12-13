class neutron::agent::ovs (
    $use_namespaces  = $neutron::params::use_namespaces
    ) inherits neutron::params {

    include neutron::common
    include openstack::params
    
    $ovs_pkg = ["openvswitch-datapath-source", 
                "openvswitch-switch",
		"openvswitch-datapath-dkms",
                "quantum-plugin-openvswitch-agent"]

    File {
        owner => root,
        group => root,
        mode => 644,
    }

    package { 
        $ovs_pkg:
        ensure => installed,
    }

    # Quantum
    file {
        "/etc/quantum/plugins/openvswitch/ovs_quantum_plugin.ini": 
        ensure => present,
        require => Package[$ovs_pkg],
        content => $network_type ? {
            gre => template("neutron/ovs_quantum_plugin.ini.gre.erb"),
            vlan => template("neutron/ovs_quantum_plugin.ini.vlan.erb"),
            default => template("neutron/ovs_quantum_plugin.ini.gre.erb"),
        };
    }

    # OpenVSwitch
    exec {
        "ovs_loadmod":
        command => "/usr/bin/yes | /usr/bin/module-assistant auto-install openvswitch-datapath -t -q -f",
        unless => "/sbin/lsmod | /bin/egrep -q openvswitch",
        require => Package[$ovs_pkg];

        "ovs_vsctl":
        command => $network_type ? {
            gre => "/usr/bin/ovs-vsctl add-br br-int",
            vlan => "/usr/bin/ovs-vsctl add-br br-int; /usr/bin/ovs-vsctl add-br br-eth1; /usr/bin/ovs-vsctl add-port br-eth1 eth1;",
            default => "/usr/bin/ovs-vsctl add-br br-int;",
        },
        unless => $network_type ? {
            gre => "/sbin/ip add | /bin/egrep -q 'br-int' && /sbin/lsmod | /bin/egrep -q openvswitch",
            vlan => "/sbin/ip add | /bin/egrep -q 'br-int' && /sbin/ip add | /bin/egrep -q ' br-eth1'",
            default => "/sbin/ip add | /bin/egrep -q 'br-int'",
        },
        require => Exec[ovs_loadmod],
        #require => Package[$ovs_pkg],
        #refreshonly => true,
    }

    service {
        "openvswitch-switch":
        ensure => running,
        enable => true,
        hasrestart => true,
        hasstatus => true,
        require => Package[$ovs_pkg];
    
        "quantum-plugin-openvswitch-agent":
        ensure => running,
        enable => true,
        hasrestart => true,
        hasstatus => true,
        require => Package[$ovs_pkg],
        subscribe => File["/etc/quantum/quantum.conf", "/etc/quantum/plugins/openvswitch/ovs_quantum_plugin.ini"],
    }

}
