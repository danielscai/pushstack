#!/bin/bash

#localtime

#nameserver='8.8.8.8'
apt_cacher_host='xm1-infra-aptcacher1'
apt_cacher_ip='10.100.50.11'
puppetserver_host='xm1-auto-puppet1'
puppetserver_ip='10.100.50.21'


set_time_zone(){
    /bin/cp -rp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
}


set_dns(){
    #DNS
    cat > /etc/resolv.conf << EOF
nameserver 8.8.8.8
EOF
}


set_hosts(){
    #hosts
    cat >> /etc/hosts << EOF
$apt_cacher_ip $apt_cacher_host
$puppetserver_ip $puppetserver_host
EOF
}


set_apt_cacher(){
#apt-cacher
cat > /etc/apt/apt.conf.d/01proxy  << EOF 
Acquire::http::Proxy "http://$apt_cacher_host:3142";
EOF

}

set_apt_conf(){
#apt-cacher
cat > /etc/apt/apt.conf.d/99conf  << EOF 
Acquire::Languages "none";
EOF

}



ping_apt_cacher(){
	ping $apt_cacher_host -c 4
	sleep 1
}



set_apt_source(){
#apt repo
cat > /etc/apt/sources.list << EOF
deb http://mirrors.sohu.com/ubuntu/ precise main restricted universe multiverse
deb http://mirrors.sohu.com/ubuntu/ precise-security main restricted universe multiverse
deb http://mirrors.sohu.com/ubuntu/ precise-updates main restricted universe multiverse
deb http://mirrors.sohu.com/ubuntu/ precise-proposed main restricted universe multiverse
deb http://mirrors.sohu.com/ubuntu/ precise-backports main restricted universe multiverse
deb-src http://mirrors.sohu.com/ubuntu/ precise main restricted universe multiverse
deb-src http://mirrors.sohu.com/ubuntu/ precise-security main restricted universe multiverse
deb-src http://mirrors.sohu.com/ubuntu/ precise-updates main restricted universe multiverse
deb-src http://mirrors.sohu.com/ubuntu/ precise-proposed main restricted universe multiverse
deb-src http://mirrors.sohu.com/ubuntu/ precise-backports main restricted universe multiverse
EOF
}

set_openstack_source(){
cat > /etc/apt/sources.list.d/grizzly.list <<EOF
deb  http://ubuntu-cloud.archive.canonical.com/ubuntu precise-updates/grizzly main
EOF
}

set_ceph_source(){
wget -q -O- 'https://ceph.com/git/?p=ceph.git;a=blob_plain;f=keys/release.asc' | sudo apt-key add -
echo deb http://ceph.com/debian-dumpling/ $(lsb_release -sc) main | sudo tee /etc/apt/sources.list.d/ceph.list
}

set_zabbix_source(){
wget http://repo.zabbix.com/zabbix/2.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_2.0-1precise_all.deb
dpkg -i zabbix-release_2.0-1precise_all.deb
}

set_puppet_source(){
cat > /etc/apt/sources.list.d/puppetlabs.list <<EOF
# Puppetlabs products
deb http://apt.puppetlabs.com precise main
deb-src http://apt.puppetlabs.com precise main

# Puppetlabs dependencies
deb http://apt.puppetlabs.com precise dependencies
deb-src http://apt.puppetlabs.com precise dependencies

# Puppetlabs devel (uncomment to activate)
# deb http://apt.puppetlabs.com precise devel
# deb-src http://apt.puppetlabs.com precise devel
EOF
}


set_puppet_source_wget(){
#puppet repo
wget http://apt.puppetlabs.com/puppetlabs-release-precise.deb -O puppetlabs-release-precise.deb
dpkg -i puppetlabs-release-precise.deb
}

set_puppet_source_file(){
    echo ''
}

apt_update(){
apt-get update
}


install_puppet_agent(){
#puppet install
apt-get install puppet facter -y
}

install_cloud_keyring(){
apt-get -y install ubuntu-cloud-keyring 
}


puppet_init(){
puppet agent -t -d --ca_server $puppetserver_host --server $puppetserver_host --environment "$1"
}

#set_puppet_server(){
#cat >> /etc/puppet/puppet.conf << EOF
#ca_server=sh1-mgmt-puppet1
#server=sh1-mgmt-puppet1
#EOF
#}

start_puppet_agent(){
#upstart
sed -i 's/START=no/START=yes/' /etc/default/puppet
service puppet restart

}


ubuntu_puppet(){
    # basic 
    set_time_zone
    set_dns
    set_hosts

    # apt 
    set_apt_cacher
    set_apt_conf
    ping_apt_cacher
    set_apt_source
    set_openstack_source
    set_ceph_source
    set_zabbix_source
    set_puppet_source
    set_puppet_source_wget
    apt_update

    # puppet
    install_puppet_agent
    install_cloud_keyring
    puppet_init "production"
    start_puppet_agent
}

centos_puppet(){
	echo ''
}

main(){
    ubuntu_puppet $@
}

main $@
exit 0
