class rabbitmq::repo (
    $apt_mirror_ip=$rabbitmq::params::apt_mirror_ip
) inherits rabbitmq::params {
  case $operatingsystem {
    RedHat: {
        apt::source { 'rabbitmq':
            location    => 'http://ubuntu-cloud.archive.canonical.com/ubuntu',
            release     => 'precise-updates/grizzly',
            repos       => 'main',
            include_src => false,
            key         => 'EC4926EA',
            key_content => template('openstack-grizzly/openstack-grizzly.asc.erb'),
        }
    }
    /(Ubuntu|Debian)/: {
        apt::source { 'rabbitmq':
            #location    => 'http://www.rabbitmq.com/debian/',
            location    => "http://$apt_mirror_ip/debian/",
            release     => 'testing',
            repos       => 'main',
            include_src => false,
            key         => '056E8E56',
            key_content => template("$module_name/rabbit.asc.erb"),
        }
    }
  }
}
