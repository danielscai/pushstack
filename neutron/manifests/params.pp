class neutron::params (
    ) {
    $enable = true
    $network_type = 'vlan'

    if $openstack::params::network_bridge {
        $network_bridge =  $openstack::params::network_bridge
    } else {
        $network_bridge = 'linuxbridge'
    }
    

    $physical_interface_mappings = $openstack::params::physical_interface_mappings
    $network_vlan_ranges = $openstack::params::network_vlan_ranges

    $linuxbridge_ini='/etc/quantum/plugins/linuxbridge/linuxbridge_conf.ini'
    $openvswitch_ini='/etc/quantum/plugins/openvswitch/ovs_quantum_plugin.ini'
        
    $linuxbridge_core_plugin = 'quantum.plugins.linuxbridge.lb_quantum_plugin.LinuxBridgePluginV2'
    $openvswitch_core_plugin = 'quantum.plugins.openvswitch.ovs_quantum_plugin.OVSQuantumPluginV2'

    $linuxbridge_driver='quantum.agent.linux.interface.BridgeInterfaceDriver'
    $openvswitch_driver='quantum.agent.linux.interface.OVSInterfaceDriver'


    $plugin_ini = $network_bridge ? {
        'linuxbridge' => $linuxbridge_ini,
        'ovs' => $openvswitch_ini,
        default => $linuxbridge_ini,
    }

    $core_plugin = $network_bridge ? {
        'linuxbridge' => $linuxbridge_core_plugin,
        'ovs' => $openvswitch_core_plugin,
        default => $linuxbridge_core_plugin,
    }

    if $openstack::params::use_namespaces {
        $use_namespaces = $openstack::params::use_namespaces
    } else {
        $use_namespaces = "True"
    }
   
    if $openstack::params::use_namespace_l3 {
        $use_namespaces_l3 = $openstack::params::use_namespace_l3
    } else {
        $use_namespaces_l3 = "True"
    }

    if $openstack::params::external_network_bridge {
        $external_network_bridge = $openstack::params::external_network_bridge
    } else {
        $external_network_bridge = $network_bridge ? {
            'linuxbridge' => '',
            'ovs' => 'br-ex',
            default => '',
        }
    }
    
}
