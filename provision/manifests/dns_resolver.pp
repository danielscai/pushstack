class provision::dns_resolver (
    $dns_servers = $provision::params::dns_servers,
    $dns_search = $provision::params::dns_search,
    ) inherits provision::params {

    class { 'resolver':
          dns_servers => $dns_servers,
          search      => $dns_search,
          template => ('resolver/resolv.conf.erb'),
    }
}
