$ceph_conf = {
    fsid =>'a316d7d6-2b18-446c-9a91-0fa36a2dc1e3',
    mon_initial_members => ['xm1-ceph-mon1','xm1-ceph-mon2','xm1-ceph-mon3'],
    mon_host => ['10.100.40.11','10.100.40.12','10.100.40.13'],
    public_network => '10.100.40.0/24',
    cluster_network => '10.100.41.0/24',
}
