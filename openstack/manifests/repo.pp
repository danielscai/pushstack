class openstack::repo (
    $version = $openstack::repo_params::version,
    ) inherits openstack::repo_params {

  case $operatingsystem {
    RedHat: {
        include openstack::repo::rhel
    }
    /(Ubuntu|Debian)/: {
        include openstack::repo::apt
    }
  }
}
