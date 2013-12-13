class cinder::cinder_volume {
    package { "cinder-volume" :
        ensure => installed,
    }
}
