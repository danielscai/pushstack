class cobbler::params {

  # /etc/cobbler
  # modules
  $authentication_module = 'authn_configfile'

  # settings
  $allow_dynamic_settings = 1
  # openssl passwd -1
  $default_password_crypted = '$1$w8hk7ip4$1i4vWJRt1EdSD7CxSPLEY0'
  $manage_dhcp = 1
  $next_server = $ipaddress_eth1
  $pxe_just_once = 1
  $restart_dhcp = 1
  $cobbler_server = $ipaddress_eth1

  # dhcp.template
}
