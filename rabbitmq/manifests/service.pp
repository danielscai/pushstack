
class rabbitmq::service (
    $rabbitmq_listen_port = 5672,
    $rabbitmq_listen_ip = $::ipaddress,
    ) {
 
    include rabbitmq::repo    
   
    $pkg='rabbitmq-server'
    $service='rabbitmq-server'

    package {
        $pkg:
        ensure => latest,
    }
    
    file {
        '/etc/rabbitmq/rabbitmq-env.conf':
        owner => root,
        group => root,
        mode => 0644,
	    require => Package["$pkg"],
        content => template("rabbitmq/rabbitmq-env.conf.erb");
        
        '/etc/rabbitmq/rabbitmq.conf.d':
        ensure => directory,
	    require => Package["$pkg"],
        recurse => true, purge => true, force => true;
    }

    service {
        $service:
        require => File["/etc/rabbitmq/rabbitmq-env.conf"],
        ensure => running,
        subscribe => File["/etc/rabbitmq/rabbitmq-env.conf","/etc/rabbitmq/rabbitmq.conf.d"];
    }
    
    Class[rabbitmq::repo] -> Class[rabbitmq::service]
}
