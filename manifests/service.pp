# Private class
define haproxy::service (
  $instance_name,
  $service_ensure,
  $service_manage,
  $restart_command = undef,
) {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  if $service_manage {
    if ($::osfamily == 'Debian') {
      file { "/etc/default/${instance_name}":
        content => 'ENABLED=1',
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
