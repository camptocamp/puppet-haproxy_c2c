class haproxy {
  package {"haproxy":
    ensure => present
  }

  service {"haproxy":
    ensure => running,
    enable => true,
    subscribe => [File["haproxy_default"], File["haproxy_config"]],
    hasstatus => true,
    restart   => "/etc/init.d/haproxy reload",
  }

  file {"haproxy_default":
    name    => "/etc/default/haproxy",
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => "644",
    require => Package["haproxy"],
  }

  file {"haproxy_config":
    name    => "/etc/haproxy/haproxy.cfg",
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => "644",
    require => Package["haproxy"],
    notify  => Service["haproxy"],
  }

  # Augeas lens
  file {"/etc/haproxy/haproxy.aug":
    ensure  => present,
    source  => "puppet:///modules/haproxy/haproxy.aug",
    owner   => "root",
    group   => "root",
    mode    => 644,
    require => Package["haproxy"],
  }

  augeas {"enable haproxy" :
    context => "/files/etc/default/haproxy",
    changes => "set ENABLED 1",
    onlyif  => "get ENABLED != 1",
    require => File["haproxy_default"],
 }
}
