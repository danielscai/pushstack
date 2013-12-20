class provision::params {

    #if ! $::puppetmaster {
    #    fail {'puppetmaster not defined': }
    #}

    #$puppetmaster = $::puppetmaster

    if $::apt_cacher_server {
        $apt_cacher_server = $::apt_cacher_server
    } else {
        $apt_cacher_server = false
    }

    if $::dns_servers {
        $dns_servers = $::dns_servers
    } else {
        $dns_servers = [ '114.114.114.114' , '8.8.8.8' ]
    }
    
    if $::dns_search {
        $dns_search =  $::dns_search
        $enable_dns_search = true
    } else {
        $dns_search = ''
        $enable_dns_search = false
    }

    if $::apt_ubuntu_url {
        $apt_ubuntu_url = $::apt_ubuntu_url
    }

}
