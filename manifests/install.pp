# Private class
define haproxy::install (
  $package_name = undef,
  $package_ensure,
) {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  if $package_name != undef {
    package { $package_name:
      ensure => $package_ensure,
      alias  => 'haproxy',
    }
  }
}
