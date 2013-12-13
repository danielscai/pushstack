class pacemaker::stonith (
    $disable=true
    ) inherits pacemaker::corosync {


    case $::operatingsystem {
        ubuntu, debian:
            { 
                $cmd = '/usr/sbin/crm configure property stonith-enabled=false && /usr/sbin/crm configure property no-quorum-policy=ignore' 
                $unless_cmd = '/usr/sbin/crm configure show | grep stonith | grep false'

                $enable_cmd='/usr/sbin/crm configure property stonith-enabled=true'
            }
        centos, redhat:
            { 
                $cmd = "/usr/sbin/pcs property set stonith-enabled=false"
                $unless_cmd = "/usr/sbin/pcs property show stonith-enabled | grep stonith-enabled | grep false"

                $enable_cmd="/usr/sbin/pcs property set stonith-enabled=true"
            }
    }

  if $disable == true {
    exec {"Disable STONITH":
        command => $cmd,
        unless => $unless_cmd,
        #require => Exec["Start Cluster $cluster_name"],
    }
  } else {
    exec {"Enable STONITH":
        command => $enable_cmd,
        onlyif => $unless_cmd,
        #require => Exec["Start Cluster $cluster_name"],
    }
  }
}
