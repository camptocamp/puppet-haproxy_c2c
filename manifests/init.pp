class haproxy {
  package {"haproxy":
    ensure => present
  }

  service {"haproxy":
    ensure => running,
    enable => true,
    subscribe => [File["/etc/default/haproxy"], File["/etc/haproxy/haproxy.cfg"]],
  }

  file {"/etc/default/haproxy":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => "644",
    require => Package["haproxy"],
  }

  file {"/etc/haproxy/haproxy.cfg":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => "644",
    require => Package["haproxy"],
  }

  augeas {"enable haproxy" :
    context => "/files/etc/default/haproxy",
    changes => "set ENABLED 1",
    onlyif  => "get ENABLED != 1",
 }
}
