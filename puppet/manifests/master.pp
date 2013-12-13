class puppet::master (
  $enable = $puppet::params::master_enable,
  $version = $puppet::params::master_version,
  $autosign = $puppet::params::autosign,
) inherits puppet::params {

  $master_pkgs = $puppet::params::master_pkgs
  package { $master_pkgs:
    ensure => $version,
  }

  file { "/etc/puppet/autosign.conf":
    content => template("$module_name/autosign.erb"),
    require => Package[$master_pkgs],
  }

  if $enable {
    $master_service_ensure = 'running'
    $master_service_enable = 'true'
  } else {
    $master_service_ensure = 'stopped'
    $master_service_enable = 'false'
  }

  service { 'puppetmaster':
    ensure => $master_service_ensure,
    enable => $master_service_enable,
    require => Package[$master_pkgs],
  }

}
