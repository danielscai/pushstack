class glance::utils (
    ) inherits glance::params{

    file {
        "/root/keystone/download_cirros_image.sh":
        mode => 755,
        content => template("$module_name/utils/download_cirros_image.sh.erb");
    }
}
