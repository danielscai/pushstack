class provision::sources_list (
    $apt_ubuntu_url = $provision::params::apt_ubuntu_url
) inherits provision::params {

    file {'/etc/apt/sources.list':
        ensure => present,
        content => template("$module_name/sources.list.erb");
    }
}
