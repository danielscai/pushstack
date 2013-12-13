
class oshotfix::vnc_401_error ( 
    ) inherits oshotfix::params {
    include nova::python_nova
    
    file { "/usr/share/pyshared/nova/console/websocketproxy.py":
        content => template("oshotfix/websocketproxy.py.erb"),
        require => Package['python-nova'],
    }

}
