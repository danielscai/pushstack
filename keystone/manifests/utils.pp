class keystone::utils {

    include osinit::utils

    file {
        "/root/keystone/03-keystone_basic.sh":
        mode => 755,
        content => template("keystone/keystone/keystone_basic.sh.erb");

        "/root/keystone/04-keystone_endpoints_basic.sh":
        mode => 755,
        content => template("keystone/keystone/keystone_endpoints_basic.sh.erb");
    
        "/root/keystone/01-mysql_init.sh":
        mode => 755,
        content => template("keystone/keystone/mysql_init.sh.erb");

        "/root/keystone/02-db_sync.sh":
        mode => 755,
        content => template("keystone/keystone/db_sync.sh.erb");

        "/root/keystone/restart_service.sh":
        mode => 755,
        content => template("keystone/keystone/restart_service.sh.erb");  
        
    }

}
