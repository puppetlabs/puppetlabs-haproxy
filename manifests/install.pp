# @summary Install haproxy
# @param install_options
#   Array of arguments passed to the installer
# @api private
define haproxy::install (
  # lint:ignore:140chars
  Variant[Enum['present', 'absent', 'purged', 'disabled', 'installed', 'latest'], String[1]] $package_ensure,
  Optional[String]  $package_name     = undef,  # A default is required for Puppet 2.7 compatibility. When 2.7 is no longer supported, this parameter default should be removed.
  # lint:endignore
  Array[String[1]] $install_options = [],
) {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  if $package_name != undef {
    package { $package_name:
      ensure          => $package_ensure,
      install_options => $install_options,
      alias           => 'haproxy',
    }
  }
}
