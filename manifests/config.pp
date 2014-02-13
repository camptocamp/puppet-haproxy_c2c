define haproxy_c2c::config ($ensure) {
  augeas { "haproxy.${name}":
    incl    => '/etc/haproxy/haproxy.cfg',
    lens    => 'Haproxy.lns',
    changes => "set 'haproxy.${name}' '${ensure}'",
    notify  => Service['haproxy'],
  }
}
