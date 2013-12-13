class cobbler::repo::epel {

    $source_name = "epel"
    $release = $::operatingsystemmajrelease

    yumrepo { "$source_name":
        baseurl  => "http://download.fedoraproject.org/pub/epel/6/\$basearch/",
        descr    => "$source_name $release - \$basearch",
        enabled  => '1',
        gpgcheck => '0',
        #gpgkey   => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-$release",
    }

    yumrepo { "$source_name-testing":
        baseurl  => "http://download.fedoraproject.org/pub/epel/testing/6/\$basearch/",
        descr    => "$source_name-testing $release - \$basearch",
        enabled  => '1',
        gpgcheck => '0',
        #gpgkey   => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-$release",
    }

}
