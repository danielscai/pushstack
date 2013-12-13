class cobbler::repo::puppetlabs {


    file { "/etc/yum.repos.d.bak/":
        ensure => directory,
    }

    exec { "purge_puppetlabs":
        command => "/bin/mv /etc/yum.repos.d/puppetlabs-*.repo /etc/yum.repos.d.bak/",
        onlyif => "/bin/ls /etc/yum.repos.d/ | egrep '^puppetlabs-'",
        #refreshonly => true,
    }

    define puppetlabs_source_add() {
        
        $source_name = "puppetlabs"
        $repo = $title
        $release = $::operatingsystemmajrelease
        #$systemrelease = split($::operatingsystemrelease, '[.]')
	notify { "$release - $repo": }

        yumrepo { "$source_name-$repo":
            baseurl  => "http://yum.puppetlabs.com/el/$release/$repo/\$basearch",
            descr    => "Puppet Labs Products El $release - \$basearch",
            enabled  => '1',
            gpgcheck => '0',
            #gpgkey   => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-puppetlabs',
        }
    }

    $puppetlabs_repos = [ "products", "dependencies", "devel" ]
    puppetlabs_source_add{ $puppetlabs_repos: }

}
