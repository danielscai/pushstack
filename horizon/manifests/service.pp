class horizon::service (
    $openstack_host = $horizon::params::openstack_host,
    $apache_bind_ip = $horizon::params::apache_bind_ip,
    ) inherits horizon::params {

    #$horizon_pkg = ["apache2", "libapache2-mod-wsgi", "openstack-grizzly-dashboard", "memcached", "python-memcache"]
    $horizon_pkg = ["python-django-horizon", "openstack-dashboard-ubuntu-theme"]
    $local_settings="/etc/openstack-dashboard/local_settings.py"

    package { 
        $horizon_pkg:
        ensure => installed,
    }

    file {
        $local_settings:
        ensure => present,
        require => Package[$horizon_pkg],
        content => template("horizon/local_settings.py.erb");
    }

    file {
        "/etc/apache2/ports.conf":
        ensure => present,
        content => template("horizon/ports.conf.erb"),
	require => Package[$horizon_pkg];
    }
    
    service {
        "apache2":
        ensure => running,
        enable => true,
        hasrestart => true,
        hasstatus => true,
        require => Package[$horizon_pkg],
        subscribe => File[$local_settings,"/etc/apache2/ports.conf"];
    }
}
