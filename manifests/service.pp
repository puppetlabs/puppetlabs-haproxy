# Private class
define haproxy::service (
  $instance_name,
  $service_ensure,
  $service_manage,
  $restart_command = undef,  # A default is required for Puppet 2.7 compatibility. When 2.7 is no longer supported, this parameter default should be removed.
  $service_options = $haproxy::params::service_options,
  $sysconfig_options = $haproxy::params::sysconfig_options,
) {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  if $service_manage {
    if ($::osfamily == 'Debian') {
      file { "/etc/default/${instance_name}":
        content => $service_options,
        before  => Service[$instance_name],
      }
    }
    if ($::osfamily == 'Redhat') {
      file {"/etc/sysconfig/${instance_name}":
        content => $sysconfig_options,
        before  => Service[$instance_name],
      }
    }

    $_service_enable = $service_ensure ? {
        'running' => true,
        'stopped' => false,
        default   => $service_ensure,
    }

    service { $instance_name:
      ensure     => $service_ensure,
      enable     => $_service_enable,
      name       => $instance_name,
      hasrestart => true,
      hasstatus  => true,
      restart    => $restart_command,
    }
  }
}
