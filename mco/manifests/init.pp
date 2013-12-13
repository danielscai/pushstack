class mco {
    case $hostname {
        $mcocontroller: {
            #include int::mco::activemq
            #include int::mco::rabbitmq
        }
    }
    include mco::server
}

