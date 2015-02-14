exec { "apt-update":
    command => "/usr/bin/apt-get update"
}

Exec["apt-update"] -> Package <| |>

group { "puppet":
  ensure => "present",
}

class { '::mysql::server':
  override_options => { 
    'mysqld' => {
      'server-id' => '2'
    }
  }
}

exec { "join_master":
    command => "mysql -uroot -e \"STOP SLAVE;  CHANGE MASTER to MASTER_HOST='192.168.30.100', MASTER_USER='repl', MASTER_PASSWORD='repl', MASTER_LOG_FILE='mysql-bin.000001', MASTER_LOG_POS=449; START SLAVE\"",
    path    => "/usr/local/bin/:/bin/:/usr/bin",
    # path    => [ "/usr/local/bin/", "/bin/" ],  # alternative syntax
}
