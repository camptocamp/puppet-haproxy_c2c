class haproxy {
  package {"haproxy":
    ensure => present
  }

  service {"haproxy":
    ensure    => running,
    enable    => true,
    require   => Augeas['enable haproxy'],
    hasstatus => true,
    restart   => "/etc/init.d/haproxy reload",
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

  augeas { 'enable haproxy':
    incl    => '/etc/default/haproxy',
    lens    => 'Shellvars.lns',
    changes => 'set ENABLED 1',
    require => Package["haproxy"],
  }

  augeas::lens { 'haproxy':
    ensure      => present,
    lens_source => 'puppet:///modules/haproxy/haproxy.aug',
  }
}
