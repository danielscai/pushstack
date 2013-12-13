# == Class: rabbitmq
#
# Full description of class rabbitmq here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if it
#   has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should not be used in preference to class parameters  as of
#   Puppet 2.6.)
#
# === Examples
#
#  class { rabbitmq:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ]
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2013 Your name here, unless otherwise noted.
#

class rabbitmq (
    $rabbitmq_listen_ip = $::ipaddress,
    $rabbitmq_user = $rabbitmq::params::rabbitmq_user,
    $rabbitmq_password = $rabbitmq::params::rabbitmq_password ,
    $rabbitmq_port= $rabbitmq::params::rabbitmq_port,
    ) inherits rabbitmq::params {
    include rabbitmq::repo
    
    class {'rabbitmq::service': 
        rabbitmq_listen_port => $rabbitmq_port,
        rabbitmq_listen_ip => $rabbitmq_listen_ip,
    }
}
