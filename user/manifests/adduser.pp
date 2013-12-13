define user::adduser (
  $username='', $useruid='', $usergid='', $usershell='/bin/bash', $userpass='$1$5M3261$jLDwe5OWFW9ruJtWAQ/nM1'
) {
  group { $username: gid => $usergid; }

  user { $username:
      uid   => $useruid,
      gid   => $usergid,
      shell => $usershell,
      password => $userpass,
      #ensure => absent,
      #groups => $groups,
      #home  => "/home/$username",
      require => Group[$username],
  }

  file { "/home/$username":
      owner   => $useruid,
      group   => $usergid,
      mode    => 700,
      ensure  => directory;
  }

  file { "/home/$username/.ssh":
      owner   => $useruid,
      group   => $usergid,
      mode    => 700,
      ensure  => directory,
      require => File["/home/$username"];
  }

  file { "/home/$username/.ssh/authorized_keys":
      owner   => $useruid,
      group   => $usergid,
      mode    => 600,
      ensure  => present, 
      content => template("user/${username}_authorized_keys.erb"),
      require => File["/home/$username/.ssh"]; 
  }

  #file { "/home/$username/.bash_profile":
  #    owner   => $useruid,
  #    group   => $usergid,
  #    mode    => 600,
  #    ensure  => present,
  #    content => template("user/bash_profile.erb"),
  #    require => File["/home/$username"];
  #}

  #file { "/home/$username/.bashrc":
  #    owner   => $useruid,
  #    group   => $usergid,
  #    mode    => 600,
  #    ensure  => present,
  #    content => template("user/bashrc.erb"),
  #    require => File["/home/$username"];
  #}
}


