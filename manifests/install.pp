# Private class
class haproxy::install inherits haproxy {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  package { $package_name:
    ensure  => $_package_ensure,
    alias   => 'haproxy',
  }

  # Create default configuration directory, gentoo portage does not create it
  file { '/etc/haproxy':
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    require => Package["$package_name"]
  }
}
