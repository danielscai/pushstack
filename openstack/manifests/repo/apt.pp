class openstack::repo::apt (
    $apt_mirror_ip=$openstack::params::apt_mirror_ip
) inherits openstack::params {
      
    apt::source { 'grizzly':
        #location    => "http://ubuntu-cloud.archive.canonical.com/ubuntu",
        location    => "http://$apt_mirror_ip/ubuntu",
        release     => 'precise-updates/grizzly',
        repos       => 'main',
        include_src => false,
        key         => 'EC4926EA',
        key_content => template('openstack/openstack-grizzly.asc.erb'),
    }

    #exec { "apt-update":
    #command => "/usr/bin/apt-get update"
    #}
    
    #Apt::Source <||> -> Exec["apt-update"]
    Exec['apt_update'] -> Package<||>
}
