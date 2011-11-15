define haproxy::config ($ensure) {
  haproxy::augeas {$name:
    changes => "set '${name}' '${ensure}'",
  }
}
