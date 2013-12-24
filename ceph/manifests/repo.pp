class ceph::repo (
    $apt_mirror_ip=$ceph::params::apt_mirror_ip,
    $release='emperor',
) inherits ceph::params {
    case $operatingsystem {

        /(Ubuntu|Debian)/: {
            apt::key { 'ceph':
                key        => '17ED316D',
                key_source => 'https://ceph.com/git/?p=ceph.git;a=blob_plain;f=keys/release.asc',
            }    
           
            apt::source { 'ceph':
                #location    => 'http://ceph.com/debian-emperor/',
                location    => "http://$apt_mirror_ip/debian-$release/",
                release     => "$::lsbdistcodename",
                repos       => 'main',
                include_src => false,
                #key         => '17ED316D',
                #key_content => template("$module_name/rabbit.asc.erb"),
            }
        } 

        RedHat: {
            yumrepo { 'grizzly-release':
                baseurl  => "http://ceph.com/rpm-$release/rhel6/$basearch",
                descr    => 'OpenStack Grizzly Repository',
                enabled  => 1,
                gpgcheck => 1,
                gpgkey   => 'https://ceph.com/git/?p=ceph.git;a=blob_plain;f=keys/release.asc',
                priority => 98,
                notify   => Exec['yum_refresh'],
            }

            exec { 'yum_refresh':
                command     => '/usr/bin/yum clean all',
                refreshonly => true,
            }

            Exec['yum_refresh'] -> Package<||>
            Yumrepo['grizzly-release'] -> Package<||>   
        }
    }   
}
