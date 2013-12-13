class osinit::env {

    include osinit::utils

    file {
        "/root/keystone/creds":
        content => template("$module_name/creds.erb");

        "/root/.bash_aliases":
        content => template("$module_name/bash_aliases.erb");
    }
}
