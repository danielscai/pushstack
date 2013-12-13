class glance::glance_install {
        
    include openstack::params 
    include nova::user
    
    include glance::glance_api
    include glance::glance_registry
    include glance::python_glanceclient
    include glance::glance_common
    include glance::utils
   
    Class[nova::user] -> Package<||>
}
