class nova::common (
    $enable_metadata_proxy = $nova::params::enable_metadata_proxy,
    $enable_config_drive = $nova::params::enable_config_drive,
    ) inherits nova::params{

    package { 'nova-common':
      ensure => 'installed',
    }

    @file {
        "nova-api-paste.ini":
        path => "/etc/nova/api-paste.ini",
        ensure => present,
        require => Package['nova-common'],
        content => template("nova/nova-api-paste.ini.erb");
    }

    @file {
        "nova.conf":
        path => "/etc/nova/nova.conf",
        require => Package['nova-common'],
        content => template("nova/nova.conf.erb");
    }
}
