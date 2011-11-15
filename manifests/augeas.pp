define haproxy::augeas ($changes, $onlyif = undef) {
  augeas {"haproxy.${name}":
    context   => "/files/etc/haproxy/haproxy.cfg",
    changes   => $changes,
    onlyif    => $onlyif,
    load_path => "/etc/haproxy",
    notify    => Service["haproxy"],
  }
}
