class ceph::repo {
    case $operatingsystem {

        /(Ubuntu|Debian)/: {
            apt::key { 'ceph':
                key        => '17ED316D',
                key_source => 'https://ceph.com/git/?p=ceph.git;a=blob_plain;f=keys/release.asc',
            }    
           
            apt::source { 'ceph':
                location    => 'http://ceph.com/debian-emperor/',
                release     => "$::lsbdistcodename",
                repos       => 'main',
                include_src => false,
                #key         => '17ED316D',
                #key_content => template("$module_name/rabbit.asc.erb"),
            }
        } 
    }   
}
