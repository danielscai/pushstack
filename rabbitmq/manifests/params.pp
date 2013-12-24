
class rabbitmq::params {

    if  $::apt_mirror_ip {
        $apt_mirror_ip = $::apt_mirror_ip
    } else {
        $apt_mirror_ip = 'www.rabbitmq.com'
    } 

    $rabbitmq_user = 'guest'
    $rabbitmq_password = 'guest'
    $rabbitmq_port=5672
}
