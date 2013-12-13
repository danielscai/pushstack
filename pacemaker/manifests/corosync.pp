class pacemaker::corosync(
    $cluster_name, 
    $cluster_members
    ) inherits pacemaker {

    #firewall { '001 corosync mcast':
    #    proto    => 'udp',
    #    dport    => ['5404', '5405'],
    #    action   => 'accept',
    #}
    $bindnetaddr=$::ipaddress

    $corosync_pkg=["pacemaker", "corosync", "cman"]

    package {$corosync_pkg:
	    ensure  => "installed",
    }

    file {"/etc/corosync/corosync.conf": 
        ensure => present,
        require => Package[$corosync_pkg],
        content => template("$module_name/corosync.conf.erb");

        "/etc/default/corosync":
        ensure => present,
        require => Package[$corosync_pkg],
        content => template("$module_name/default_corosync.erb");

        "/usr/lib/ocf/resource.d/heartbeat/haproxy":
        ensure => present,
        require => Package[$corosync_pkg],
        mode => 755,
        content => template("$module_name/haproxy.erb");
    }

    exec {"Set corosync running level":
        command => "/usr/sbin/update-rc.d -f corosync remove && /usr/sbin/update-rc.d corosync start 1 2 3 4 5 . stop 50 0 6 .  ",
        creates => "/etc/rc2.d/S01corosync",
        require => Package["corosync"]
    }
        

    #exec {"Set password for hacluster user on $cluster_name":
    #    command => "/bin/echo CHANGEME | /usr/bin/passwd --stdin hacluster",
    #    creates => "/etc/cluster/cluster.conf",
    #    require => [Package["pcs"], Package["pacemaker"]]
    #}
    #
    #exec {"Create Cluster $cluster_name":
    #    creates => "/etc/cluster/cluster.conf",
    #    command => "/usr/sbin/pcs cluster setup --name $cluster_name $cluster_members",
    #    require => [Package["pcs"], Package["cman"]],
    #}

    #exec {"Start Cluster $cluster_name":
    #    unless => "/usr/sbin/pcs status > /dev/null 2>&1",
    #    command => "/usr/sbin/pcs cluster start",
    #    require => Exec["Create Cluster $cluster_name"],
    #}

    exec {"Start Cluster $cluster_name":
        unless => "/usr/sbin/crm status > /dev/null 2>&1",
        command => "/etc/init.d/corosync start",
        require => Service["corosync"],
    }

    service {
        ["corosync"]:
        require => Package['corosync'],
        ensure => running,
        subscribe => File['/etc/corosync/corosync.conf'];
    }
}
