$ceph_conf = {
    fsid => 'a1fadefe-6068-4d10-8c53-4a864beab049',
    mon_initial_members => ['ceph1','ceph2','ceph3'],
    mon_host => ['10.1.1.60','10.1.1.61','10.1.1.62'],
    public_network => '10.1.1.0/24',
    cluster_network => '10.1.2.0/24',
}
