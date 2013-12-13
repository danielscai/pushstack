class ceph::params {
    if ! $::ceph_conf {
        fail (" ceph_conf hash not defined ! ")
    }

    if ! has_key($::ceph_conf, 'fsid')
        or ! has_key($::ceph_conf, 'mon_initial_members')
        or ! has_key($::ceph_conf, 'mon_host') {
        fail (" ceph fsid/mon_initial_members/mon_host not defined ! ")
    }
    

    $fsid = $::ceph_conf['fsid']
    $mon_host  = $::ceph_conf['mon_host']
    $mon_initial_members = $::ceph_conf['mon_initial_members']


    if has_key($::ceph_conf, 'public_network') {
        $public_network = $::ceph_conf['public_network'] 
    }
    
    if has_key($::ceph_conf, 'cluster_network') {
        $cluster_network = $::ceph_conf['cluster_network']
    }

    if has_key($::ceph_conf, 'auth_supported') {
        $auth_supported = $::ceph_conf['auth_supported']
    } else {
        $auth_supported='none'
    }

    if has_key($::ceph_conf, 'osd_journal_size') {
        $osd_journal_size = $::ceph_conf['osd_journal_size']
    } else {
        $osd_journal_size='1024'
    }

    if has_key($::ceph_conf, 'filestore_xattr_use_omap') {
        $filestore_xattr_use_omap = $::ceph_conf['filestore_xattr_use_omap']
    } else {
        $filestore_xattr_use_omap='true'
    }
}
