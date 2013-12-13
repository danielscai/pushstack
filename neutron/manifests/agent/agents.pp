import 'quantum-common.pp'

class neutron::agent::lbaas{
    include neutron::common
    include neutron::agent::ovs
    $quantum_lbaas_agent_pkg = ['quantum-lbaas-agent', 'haproxy']

    File {
        owner => root,
        group => root,
        mode => 644,
    }

    package { 
        [$quantum_lbaas_agent_pkg]:
        ensure => installed,
        #provider => apt,
    }

    file {
        "/etc/quantum/lbaas_agent.ini":
        ensure => present,
        require => Package[$quantum_lbaas_agent_pkg],
        content => template("openstack-grizzly/lbaas_agent.ini.erb");

        ["/etc/quantum/plugins", "/etc/quantum/plugins/services", "/etc/quantum/plugins/services/agent_loadbalancer"]:
        owner => root, group => quantum, mode => 755,
        ensure => directory;

        "/etc/quantum/plugins/services/agent_loadbalancer/lbaas_agent.ini":
        owner => root, group => quantum, mode => 644,
        ensure => present,
        require => File["/etc/quantum/plugins/services/agent_loadbalancer"],
        content => template("openstack-grizzly/lbaas_agent.ini.erb");
    }

    service {
        ["quantum-lbaas-agent"]:
        ensure => running,
        enable => true,
        hasrestart => true,
        hasstatus => true,
        require => Package[$quantum_lbaas_agent_pkg],
        subscribe => File["/etc/quantum/lbaas_agent.ini"]
    }
}

class neutron::agent::dhcp_l3{
    include neutron::common
    include neutron::agent::ovs
    $quantum_pkg = ['quantum-dhcp-agent', 'quantum-l3-agent','bridge-utils']

    File {
        owner => root,
        group => root,
        mode => 644,
    }

    package { 
        [$quantum_pkg]:
        ensure => installed,
        #provider => apt,
    }

    file {
        "/etc/quantum/l3_agent.ini":
        ensure => present,
        require => Package[$quantum_pkg],
        content => template("openstack-grizzly/l3_agent.ini.erb");

        "/etc/quantum/dhcp_agent.ini":
        ensure => present,
        require => Package[$quantum_pkg],
        content => template("openstack-grizzly/dhcp_agent.ini.erb");
    }

    exec {
        "ovs_vsctl_l3":
        command => $network_type ? {
            gre => "/usr/bin/ovs-vsctl add-br br-ex && /usr/bin/ovs-vsctl add-port br-ex $external_network_device",
            vlan => "/usr/bin/ovs-vsctl add-br br-int; /usr/bin/ovs-vsctl add-br br-eth1; /usr/bin/ovs-vsctl add-port br-eth1 eth1;",
            default => "/usr/bin/ovs-vsctl add-br br-ex;",
        },
        unless => $network_type ? {
            gre => "/sbin/ip add | /bin/egrep -q 'br-ex' && /sbin/lsmod | /bin/egrep -q openvswitch",
            vlan => "/sbin/ip add | /bin/egrep -q 'br-int' && /sbin/ip add | /bin/egrep -q ' br-eth1'",
            default => "/sbin/ip add | /bin/egrep -q 'br-int'",
        },
        require => Exec[ovs_loadmod],
        #require => Package[$ovs_pkg],
        #refreshonly => true,
    }

    service {
        ["quantum-dhcp-agent","quantum-l3-agent"]:
        ensure => running,
        enable => true,
        hasrestart => true,
        hasstatus => true,
        require => Package[$quantum_pkg],
        subscribe => File["/etc/quantum/quantum.conf", "/etc/quantum/plugins/openvswitch/ovs_quantum_plugin.ini",
            "/etc/quantum/l3_agent.ini","/etc/quantum/dhcp_agent.ini"];
    }
}

class neutron::agent::metadata{
    include neutron::common
    include neutron::agent::ovs
    $quantum_pkg = ['quantum-metadata-agent']

    File {
        owner => root,
        group => root,
        mode => 644,
    }

    package {
        [$quantum_pkg]:
        ensure => installed,
        #provider => apt,
    }

    file {
        "/etc/quantum/metadata_agent.ini":
        ensure => present,
        require => Package[$quantum_pkg],
        content => template("openstack-grizzly/metadata_agent.ini.erb");
    }

    service {
        ["quantum-metadata-agent"]:
        ensure => running,
        enable => true,
        hasrestart => true,
        hasstatus => true,
        require => Package[$quantum_pkg],
        subscribe => File["/etc/quantum/metadata_agent.ini"];
    }
}


class neutron::agent::ovs {
    include neutron::common
    $ovs_pkg = ["openvswitch-datapath-source", 
                "openvswitch-switch",
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
            gre => template("openstack-grizzly/ovs_quantum_plugin.ini.gre.erb"),
            vlan => template("openstack-grizzly/ovs_quantum_plugin.ini.vlan.erb"),
            default => template("openstack-grizzly/ovs_quantum_plugin.ini.gre.erb"),
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
