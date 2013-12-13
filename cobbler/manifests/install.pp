class cobbler::install {

  package { [ 'cobbler', 'cobbler-web', 'rsync', 'dhcp', 'debmirror', 'pykickstart', 'fence-agents' ]:
    ensure => 'latest',
    notify => Exec["get_loaders"],
  }

}
