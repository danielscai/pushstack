
class nova::python_nova {
    $python_nova = [ "python-nova"]

    include oshotfix::network_interface_attach
    
    package { 
        $python_nova:
        ensure => installed,
        #provider => apt,
    }

    file {
        "/usr/share/pyshared/nova/network/quantumv2/api.py":
        ensure => present,
        require => Package[$python_nova],
        content => template("nova/api.py.erb");

    }
}
