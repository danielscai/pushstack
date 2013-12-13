
class provision::apt_client (
    $apt_cacher_server = $provision::params::apt_cacher_server,
    ) inherits provision::params {
    
    class {'apt': 
        proxy_host => $provision::apt_client::apt_cacher_server,
        proxy_port => '3142',
        disable_keys => true,
    }
    
    apt::conf {'nolanguages':
        content => "Acquire::Languages { \"none\"; };",
    }

}
