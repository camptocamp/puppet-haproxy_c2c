class haproxy_c2c (
  Optional[String] $haproxy_config_content = undef,
) {
  package {'haproxy':
    ensure => present,
  }

  service {'haproxy':
    ensure    => running,
    enable    => true,
    require   => Augeas['enable haproxy'],
    hasstatus => true,
    restart   => '/etc/init.d/haproxy reload',
  }

  file {'haproxy_config':
    ensure  => file,
    path    => '/etc/haproxy/haproxy.cfg',
    content => $haproxy_config_content,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['haproxy'],
    notify  => Service['haproxy'],
  }

  # Augeas lens
  file {'/etc/haproxy/haproxy.aug':
    ensure  => file,
    content => file('haproxy_c2c/haproxy.aug'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['haproxy'],
  }

  augeas { 'enable haproxy':
    incl    => '/etc/default/haproxy',
    lens    => 'Shellvars.lns',
    changes => 'set ENABLED 1',
    require => Package['haproxy'],
  }

  augeas::lens { 'haproxy':
    ensure       => present,
    lens_content => file('haproxy_c2c/haproxy.aug'),
  }
}
