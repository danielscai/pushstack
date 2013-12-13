# puppet apply -d -v init.pp

class { 'cobbler::server':
  default_password_crypted => '$1$w8hk7ip4$1i4vWJRt1EdSD7CxSPLEY0',
  next_server => '172.16.1.253',
  cobbler_server => '172.16.1.253',
}
