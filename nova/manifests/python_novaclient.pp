class nova::python_novaclient {
    package { "python-novaclient" :
        ensure => installed,
    }
}
