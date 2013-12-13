# == Class: cobbler::server
#
# This class sets up the cobbler server
#
# === Parameters
#
# [*default_password_crypted*]
#   String. OS root password generate by command: "openssl passwd -1"
#   Default: $1$w8hk7ip4$1i4vWJRt1EdSD7CxSPLEY0    # plaintext password: ZAQ!3edc
#
# [*next_server*]
#   String. Tftp server IP
#   Default: $::ipaddress_eth1
#
# [*cobbler_server*]
#   String. Cobbler server IP
#   Default: $::ipaddress_eth1
#
#
# === Examples
#   class { 'cobbler::server':
#     default_password_crypted => '$1$w8hk7ip4$1i4vWJRt1EdSD7CxSPLEY0',
#     next_server => '172.16.1.254',
#     cobbler_server => '172.16.1.253',
#   }
#

class cobbler::server (
  $authentication_module = $::cobbler::params::authentication_module,

  $allow_dynamic_settings = $::cobbler::params::allow_dynamic_settings,
  $default_password_crypted = $::cobbler::params::default_password_crypted,
  $manage_dhcp = $::cobbler::params::manage_dhcp,
  $next_server = $::cobbler::params::next_server,
  $pxe_just_once = $::cobbler::params::pxe_just_once,
  $restart_dhcp = $::cobbler::params::restart_dhcp,
  $cobbler_server = $::cobbler::params::cobbler_server,
) inherits cobbler::params {

    if $::osfamily == RedHat and $::operatingsystemmajrelease == 6 {
        #class { 'cobbler::repo::sohu': } ->
        class { 'cobbler::repo::epel': } ->
        class { 'cobbler::install': } ->
        class { 'cobbler::config':
            default_password_crypted    => $default_password_crypted,
            next_server                 => $next_server,
            cobbler_server              => $cobbler_server,
        } ->
        class { 'cobbler::service': }
    } else {
        fail("$::osfamily != RedHat and $::operatingsystemmajrelease != 6")
    }

}
