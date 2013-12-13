class cobbler::repo::sohu {

    file { "/etc/yum.repos.d.bak/":
        ensure => directory,
    }

    exec { "purge_default":
        command => "/bin/mv /etc/yum.repos.d/CentOS-*.repo /etc/yum.repos.d.bak/",
        onlyif => "/bin/ls /etc/yum.repos.d/ | egrep '^CentOS-'",
        require => File["/etc/yum.repos.d.bak/"],
        #refreshonly => true,
    }

    define sohu_source_add() {
        
        $source_name = "sohu"
        $repo = $title
        $release = $::operatingsystemmajrelease
        #$systemrelease = split($::operatingsystemrelease, '[.]')

        yumrepo { "$source_name-$repo":
            baseurl  => "http://mirrors.sohu.com/centos/\$releasever/$repo/\$basearch/",
            descr    => "$source_name $release - \$basearch",
            enabled  => '1',
            gpgcheck => '0',
            #gpgkey   => "http://mirror.centos.org/centos/RPM-GPG-KEY-CentOS-$operatingsystemmajrelease"
        }
    }

    $puppetlabs_repos = [ "os", "updates", "extras" ]
    sohu_source_add { $puppetlabs_repos: }

}
