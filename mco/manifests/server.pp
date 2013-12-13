class mco::server {
    $mco_host = $mcocontroller
    $mco_user = "mcollective"
    $mco_pass = "evitcellocm"
    $mco_port = "61613"
    $mco_psk = "klot2oj2ked2tayn3hu5on72"

    case $operatingsystem {
        Ubuntu: {
            $mco_libdir = "/usr/share/mcollective/plugins"
            $mco_diff_pkg = [ "ruby-stomp" ]
        }
        default: {
            $mco_libdir = "/usr/libexec/mcollective"
            $mco_diff_pkg = [ "rubygem-stomp" ]
        }
    }

    #$java_pkg = ["openjdk-6-jre-headless", "openjdk-6-jre"]
    $mco_pkg = [ "mcollective-common", "mcollective", "mcollective-client" ]
    $mco_plugins_pkg = ["mcollective-puppet-agent", "mcollective-puppet-common", "mcollective-puppet-client",
                        "mcollective-package-agent", "mcollective-package-common", "mcollective-package-client",
                        "mcollective-service-agent", "mcollective-service-common", "mcollective-service-client",
                        "mcollective-filemgr-agent", "mcollective-filemgr-common", "mcollective-filemgr-client",
                        "mcollective-facter-facts",
                        "mcollective-logstash-audit",
                        "mcollective-sysctl-data",
                       ]

    $mco_all_pkg = [$mco_pkg, $mco_plugins_pkg]

    package {
        $mco_diff_pkg: ensure => latest,
    } -> package {
        $mco_pkg: ensure => latest,
    } -> package {
        $mco_plugins_pkg: ensure => latest,
    }

    #file {
    #    "$mco_libdir/mcollective": owner => root, group => root, recurse => true,
    #    #mode => 600, purge => true,
    #    source => "puppet://$fileserver/mco/mcollective",
    #    require => Package[$mco_pkg],
    #    notify => Service["mcollective"];
    #}

    file {
        "/etc/mcollective/server.cfg": owner => root, group => root, mode => 640, ensure => present,
        require => Package[$mco_all_pkg],
        content => template("mco/server.cfg.erb");

        "/etc/mcollective/client.cfg": owner => root, group => root, mode => 644, ensure => present,
        require => Package[$mco_all_pkg],
        content => template("mco/client.cfg.erb");
        }

    ## mco-gem & mco-stomp
    #file{
    #    "/opt/rubygems-1.3.7.tgz": owner => root, group => root, ensure => present,
    #    source => "puppet://$fileserver/mco/rubygems-1.3.7.tgz";

    #    "/opt/rubygem1.3.7.sh": owner => root, group => root, mode => 755, ensure => present,
    #    content => template("mco/rubygem1.3.7.sh.erb"),
    #    require => File["/opt/rubygems-1.3.7.tgz"],
    #    notify => Exec["gem_install"];
    #}

    #exec{
    #    "gem_install":
    #    command => "/opt/rubygem1.3.7.sh > /dev/null 2>&1",
    #    #unless => "/usr/bin/gem -v | egrep -q '1.3.7'",                                               
    #    unless => "/usr/bin/test -e /usr/bin/stompcat",
    #    require => File["/opt/rubygem1.3.7.sh"],
    #    #refreshonly => true,                                                                                              
    #}

    service {
        "mcollective":
        ensure => running,
        enable => true,
        hasrestart => true,
        hasstatus => true,
        require => Package[$mco_pkg, $mco_plugins_pkg],
        subscribe => File["/etc/mcollective/server.cfg"]
    }
}
