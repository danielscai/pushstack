# puppet apply -d -v /etc/puppet/modules/puppet/tests/init.pp
# default
#class { 'puppet::master':
#  enable => true,
#            # if $enable == 'false': install but disable service
#  version => 'latest',
#  autosign => [],
#}

# use special parameters
class { 'puppet::master':
  enable => true,
  version => 'latest',
  autosign => [ '*' ],
}

class { 'puppet::agent':
  version	=> 'latest',
  server	=> 'tj1-auto-mgmt1',
  ca_server	=> 'tj1-auto-mgmt1',
  environment	=> 'production',
  listen	=> 'true',
  puppetport	=> '8139',
  runinterval	=> '1800',
}
