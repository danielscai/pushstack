class openstack::repo::apt {

    #Class['openstack-grizzly::repo'] -> Class['openstack-grizzly::controller']
    apt::source { 'grizzly':
        location    => 'http://ubuntu-cloud.archive.canonical.com/ubuntu',
        release     => 'precise-updates/grizzly',
        repos       => 'main',
        include_src => false,
        key         => 'EC4926EA',
        key_content => template('openstack-grizzly/openstack-grizzly.asc.erb'),
    }
}
