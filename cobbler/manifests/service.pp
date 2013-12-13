class cobbler::service (

) inherits cobbler::params {

  # cobblerd
  service { "cobblerd":
    ensure => running,
    enable => true,
    hasrestart => true,
    hasstatus => true,
    require => Package["cobbler"],
    subscribe => File["/etc/cobbler/modules.conf", "/etc/cobbler/settings"],
  }
  

  # httpd
  service { [ "httpd", "xinetd" ]:
    ensure => running,
    enable => true,
    require => Package["cobbler-web"],
    #subscribe => File[""],
  }


  # cobbler sync
  exec { "cobbler_sync":
    command => "/usr/bin/cobbler sync",
    #refreshonly => true,
    require => Service['cobblerd']
  }

}
