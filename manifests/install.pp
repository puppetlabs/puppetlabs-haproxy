# @summary 
#   Install haproxy
# @api private
define haproxy::install (
  Boolean $package_manage,
  # lint:ignore:140chars
  Variant[Enum['present', 'absent', 'purged', 'disabled', 'installed', 'latest'], String[1]] $package_ensure,
  Optional[String]  $package_name     = undef,  # A default is required for Puppet 2.7 compatibility. When 2.7 is no longer supported, this parameter default should be removed.
  # lint:endignore
) {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  if $package_manage {
    package { $package_name:
      ensure => $package_ensure,
      alias  => 'haproxy',
    }
  }
}
