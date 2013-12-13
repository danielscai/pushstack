# zabbix api configuration setting.

class zabbix::params {

    # api
    $api_path   = '/opt/zabbixapi'
    $api_source = "puppet://$fileserver/zabbix/zabbixapi"

    case $::osfamily {
        'Debian': {
    	    $zabbix_version='1:2.0.7-1+precise'
            $package_ensure='held'

            # api - package
            $api_packages           = [ 'git', 'python-flask','python-pip', 'uwsgi-plugin-python', 'uwsgi', 'nginx' ]
            $api_packages_ensure     = 'installed'

            # api - nginx
            $api_nginx_port = '8055'
            $api_nginx_servername = 'localhost'
            $api_nginx_config       = '/etc/nginx/sites-available/zabbixapi.conf'
            $api_nginx_config_erb   = 'zabbix/zabbixapi.conf.erb'
            $api_nginx_config_link  = '/etc/nginx/sites-enabled/zabbixapi.conf'

            # api - uwsgi
            $api_uwsgi_port         = '9001'
            $api_uwsgi_host         = '127.0.0.1'
            $api_uwsgi_config       = '/etc/uwsgi/apps-available/zabbixapi.ini'
            $api_uwsgi_config_erb   = 'zabbix/zabbixapi.ini.erb'
            $api_uwsgi_config_link  = '/etc/uwsgi/apps-enabled/zabbixapi.ini'

            $api_init_path          = '/etc/init.d'
            $api_init               = 'zabbix-api'
            $api_init_erb           = 'zabbix/zabbix-api.erb'
        }

        'RedHat': {
    	    $zabbix_version='2.0.7-1.el6'
            $package_ensure='held'
        }

        default: {
            fail("The ${module_name} module is not supported on an ${::osfamily} based system.")
        }
    }
}
