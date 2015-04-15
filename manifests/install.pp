# Private class
class haproxy::install inherits haproxy {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  package { $haproxy::package_name:
    ensure => $haproxy::_package_ensure,
    alias  => 'haproxy',
  }

  # Create default configuration directory, gentoo portage does not create it
  if $::osfamily == 'Gentoo' {
    file { '/etc/haproxy':
      ensure  => directory,
      owner   => 'root',
      group   => 'root',
      require => Package["$package_name"]
    }
  }
}
