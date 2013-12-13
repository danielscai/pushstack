class provision::puppet_agent {
    #$puppetmaster = $provision::params::puppetmaster,
    #) inherits provision::params {

    class {'puppet::agent':
        #server => $provision::puppet_agent::puppetmaster,
    }
}
