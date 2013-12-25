class puppet::params {

  $autosign = [ '*' ]
  $puppet_version = 'latest'

  $master_enable = true
  $master_version = $puppet_version

  $passenger_enable = false
  $passenger_version = $puppet_version

  $agent_version = $puppet_version
  $puppetport = '8139'
  $runinterval = '1800'

  case $::osfamily {
    'RedHat': {
      $master_pkgs = [ 'puppet-server' ]
      $passenger_pkgs = [ 'puppetmaster-passenger' ]
      $agent_pkgs = [ 'puppet' ]
    }
    'Debian': {
      $master_pkgs = [ 'puppetmaster' ]
      $passenger_pkgs = [ 'puppetmaster-passenger' ]
      $agent_pkgs = [ 'puppet' ]
    }
    default: {
      fail( "$::osfamily is not supported." )
    }
  }

  $service_ensure = 'running'
  $service_enable = true

    if $::puppetmaster {
        $server = $::puppetmaster
    } else {
        $server = $servername
    }

}
