class user::deluser {
        $deluser = ["ortra"]
        user { $deluser:
            ensure => absent;
        }
}
