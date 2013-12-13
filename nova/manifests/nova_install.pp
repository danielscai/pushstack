class nova::nova_install (  
    ) inherits nova::params {
   
    include openstack::params   
    include nova::user
    include nova::common

    include nova::nova_api
    include nova::nova_cert
    include nova::nova_conductor
    include nova::nova_consoleauth
    include nova::nova_scheduler
    include nova::nova_novncproxy
    include nova::python_nova
    include nova::python_novaclient

    Class[nova::user] -> Package<||>
}
