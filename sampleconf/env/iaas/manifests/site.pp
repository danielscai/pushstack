$puppetmaster = "xm1-auto-puppet1"
$apt_cacher_server = xm1-infra-aptcacher1
$dns_servers = ['10.100.50.12']
$dns_search = 'xm1.local'

$zbx_Servers = ["172.16.136.33"]

$zbx_Server = zbx01

import "openstack.pp"
