#!/bin/sh
# wget -q http://172.16.136.230/download/os_init.sh -O os_init.sh && sh os_init.sh

# Run as root
[ -w / ] || {
echo "Need run as root"
exit 1
}

issue=$(awk 'NR==1 {print tolower($1)}' /etc/issue)

public_init() {
    /bin/cp -rp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
    download_ips="172.16.136.230"
    for ip in $download_ips; do
        r="$(ping -c 1 $ip | awk -F'[ ]+|%' '/transmitted/ {print $(NF-5)}')"
        [ $r != 100 ] && download_ip=$ip && break
    done
    
    [ ! -d /root/sh ] && mkdir -p /root/sh
    cd /root/sh
}

ubuntu_init() {
    public_init

    wget -q http://$download_ip/download/sources.list -O /etc/apt/sources.list
    wget -q http://$download_ip/download/puppetlabs-release-precise.deb -O puppetlabs-release-precise.deb
    dpkg -i puppetlabs-release-precise.deb
    
    echo 'Acquire::http::Proxy "http://172.16.136.234:3142";' > /etc/apt/apt.conf.d/01proxy
    echo 'Acquire::Languages "none";' > /etc/apt/apt.conf.d/99translations

    source_name="ceph folsom gluster rabbitmq puppetlabs"
    for s in $source_name; do
        s_list=/etc/apt/sources.list.d/$s.list
        s_asc=/etc/apt/$s.asc
    
        wget -q http://172.16.136.230/download/ubuntu/apt/$s.list -O $s_list
        wget -q http://172.16.136.230/download/ubuntu/apt/$s.asc -O $s_asc
        [ -e $s_asc ] && /usr/bin/apt-key add $s_asc
    done

    sed -i '/puppetmaster/d;$a 172.16.136.230 puppetmaster' /etc/hosts
    sed -i '/dashboard.puppet.lecast.com.cn/d;$a 172.16.136.230 dashboard.puppet.lecast.com.cn' /etc/hosts
    /usr/sbin/ntpdate puppetmaster > /dev/null 2>&1

wget -q http://172.16.136.230/download/ubuntu/archives.tgz -O /var/cache/apt/archives.tgz
cd /var/cache/apt
rm -rf archives
tar xzvf archives.tgz
cd archives
dpkg -i *.deb
    
    apt-get update
    apt-get install puppet -y
    wget -q http://$download_ip/download/puppet.conf -O /etc/puppet/puppet.conf
    puppet agent --test
}

centos_init() {
    public_init

    puppetlabs_name="puppetlabs-release-6-3.noarch.rpm"
    wget -q http://$download_ip/download/$puppetlabs_name -O $puppetlabs_name
    rpm -ivh $puppetlabs_name

    sed -i '/puppetmaster/d;$a 172.16.136.230 puppetmaster' /etc/hosts
    sed -i '/dashboard.puppet.lecast.com.cn/d;$a 172.16.136.230 dashboard.puppet.lecast.com.cn' /etc/hosts

    yum install puppet -y
    wget -q http://$download_ip/download/puppet.conf -O /etc/puppet/puppet.conf
    puppet agent --test
}

case $issue in
    centos)
        centos_init
        ;;
    ubuntu)
        ubuntu_init
        ;;
esac
