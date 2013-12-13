class osinit::utils {

    file {
        "/root/keystone/":
        ensure => directory;
    }
}
