class neutron::utils (
    ) inherits neutron::params{

    include osinit::utils 

    file {
        "/root/keystone/reset_firewall_rules.sh":
        mode => 755,
        content => template("$module_name/utils/reset_firewall_rules.sh.erb");
    }
}
