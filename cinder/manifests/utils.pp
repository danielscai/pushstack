class cinder::utils (
    ) inherits cinder::params{

    include osinit::utils 

    file {
        "/root/keystone/00-ceph_pool_make.sh":
        mode => 755,
        content => template("$module_name/utils/ceph_pool_make.sh.erb");

        "/root/keystone/05-create_volume_type.sh":
        mode => 755,
        content => template("$module_name/utils/create_volume_type.sh.erb");
    }
}
