class cobbler::config (
  $authentication_module = $::cobbler::server::authentication_module,

  $allow_dynamic_settings = $::cobbler::server::allow_dynamic_settings,
  $default_password_crypted = $::cobbler::server::default_password_crypted,
  $manage_dhcp = $::cobbler::server::manage_dhcp,
  $next_server = $::cobbler::server::next_server,
  $pxe_just_once = $::cobbler::server::pxe_just_once,
  $restart_dhcp = $::cobbler::server::restart_dhcp,
  $cobbler_server = $::cobbler::server::cobbler_server,

) inherits cobbler::params {

  # modules.conf: authentication - users.digest
  file {
    "/etc/cobbler/modules.conf":
      content => template("$module_name/modules.conf.erb");

    "/etc/cobbler/users.digest":
      #content => "#user: cobbler, password: relbboc\ncobbler:Cobbler:e4e87c86d894ecb1c12a171740cb6d63\n",
      content => "cobbler:Cobbler:e4e87c86d894ecb1c12a171740cb6d63\n";
  }


  # settings
  file { "/etc/cobbler/settings":
    content => template("$module_name/settings.erb"),
  }


  # dhcp.template
  $subnet_prefix=regsubst($cobbler_server, '^(\d+\.)(\d+\.)(\d+).\d+', '\1\2\3')    # 192.168.0
  $dhcp_subnet="$subnet_prefix.0"
  $dhcp_range="$subnet_prefix.101 $subnet_prefix.199"
  file { "/etc/cobbler/dhcp.template":
    content => template("$module_name/dhcp.template.erb"),
    #notify => Exec["cobbler_sync"],
  }


  # rsync
  file { "/etc/xinetd.d/rsync":
    content => template("$module_name/rsync.erb"),
    require => Package["rsync"],
  }  
  

  # cobbler get-loaders
  exec { "get_loaders":
    command => "/usr/bin/cobbler get-loaders",
    onlyif => "/usr/bin/cobbler check | /bin/egrep -q 'cobbler get-loaders'",
    #refreshonly => true,
  }


  # debmirror
  file { "/etc/debmirror.conf":
    content => template("$module_name/debmirror.conf.erb"),
  }

}
