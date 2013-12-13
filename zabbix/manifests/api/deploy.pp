class zabbix::api::deploy inherits zabbix::api {
    notify { "$title in $api_path, $api_init_path/$api_init": withpath => true, }

    package {
        $api_packages: ensure => $api_packages_ensure;
    }

    exec {
        "pipinstall_Flask-Actions":
        command => "/usr/bin/pip install Flask-Actions",
        #unless => "/usr/bin/test -x /usr/local/bin/flask_admin.py",
        unless => "/usr/bin/pip freeze | egrep -qi 'Flask-Actions' >/dev/null 2>&1",
        require => Package['python-pip'];
    }

    file {
        # sync api code
        $api_path:
        recurse => true, purge => true, force => true,
        source => $api_source;

        # uwsgi config
        $api_uwsgi_config:
        content => template("$api_uwsgi_config_erb"),
        require => Package['uwsgi'];

        $api_uwsgi_config_link:
        ensure => $api_uwsgi_config;

        "$api_init_path/$api_init":
        mode => 755,
        content => template('zabbix/zabbix-api.erb'),
        require => Package['uwsgi'];

        # nginx config file for zabbixapi
        $api_nginx_config:
        content => template($api_nginx_config_erb),
        require => Package["nginx"];

        $api_nginx_config_link:
        # ensure => link,
        # target => $api_nginx_config,
        ensure => $api_nginx_config;
    }

    service {
        $api_init:
        ensure => running,
        enable => true,
        hasrestart => true,
        hasstatus => true,
        require => Package["uwsgi"],
        subscribe => File[$api_uwsgi_config];

        "nginx":
        ensure => running,
        enable => true,
        hasrestart => true,
        hasstatus => true,
        require => Package["nginx"],
        subscribe => File[$api_nginx_config];
    }
}
