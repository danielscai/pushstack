class puppet::agent (
  $version = $puppet::params::agent_version,
  $server = $puppet::params::server,
  $ca_server = $server,
  $puppetport = $puppet::params::puppetport,
  $runinterval = $puppet::params::runinterval,
) inherits puppet::params {

  $agent_pkgs = $puppet::params::agent_pkgs
  package { $agent_pkgs:
    ensure => $version,
  }

  if $::osfamily == 'Debian' {
    file { "/etc/default/puppet":
      content => template("$module_name/puppet.erb"),
      require => Package[$agent_pkgs];
    }
  }

  file { "/etc/puppet/puppet.conf":
    content => template("$module_name/puppet.conf.erb"),
    require => Package[$agent_pkgs];

    "/etc/puppet/auth.conf":
    content => template("$module_name/auth.conf.erb"),
    require => Package[$agent_pkgs];
  }

  service { 'puppet':
    ensure => $service_ensure,
    enable => $service_enable,
    require => Package[$agent_pkgs],
    subscribe => File[ "/etc/puppet/puppet.conf" ],
  }

}
