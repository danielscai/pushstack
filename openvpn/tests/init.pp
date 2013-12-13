openvpn::server { 'tianjin1':
  country      => "CN",
  province     => "TJ",
  city         => "Tianjin",
  organization => "example.org",
  email        => "root@example.org",
  server       => '10.0.0.0 255.255.255.0',

  push         => [
                    "route 172.16.9.0 255.255.255.0",
                    "route 172.16.1.0 255.255.255.0",
                  ],
}

openvpn::client { [ 'xiaoliang', 'chenlei', 'caiyunfei', 'luohaocheng', 'zhuweigang' ]:
  server => 'tianjin1',
  remote_host => $::ipaddress_eth0,
}

#openvpn::client_specific_config { 'xiaoliang':
#  server   => 'tianjin1',
#  ifconfig => '10.0.0.9 255.255.255.252',
#}
