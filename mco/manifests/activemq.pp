#class mco::activemq {
#    $mq_user = "mcollective"
#    $mq_pass = "evitcellocm"
#    $mq_port = "61613"
#    $activemq_pkg = ["activemq"]
#
#    package { 
#        $activemq_pkg:
#        ensure => installed,
#        #provider => apt,
#    }
#
#    file {
#        "/etc/activemq/activemq.xml": owner => root, group => root, mode => 0755, ensure => present,
#        require => Package[$activemq_pkg],
#        content => template("mco/activemq.xml.erb"),
#    }
#
#    service {
#        "activemq":
#        ensure => running,
#        enable => true,
#        hasrestart => true,
#        hasstatus => true,
#        require => Package[$activemq_pkg],
#        subscribe => File["/etc/activemq/activemq.xml"],
#    }
#}
