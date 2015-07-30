# Private class
class haproxy::service inherits haproxy {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  if $haproxy::_service_manage {
    if ($::osfamily == 'Debian') {
      # Enable the service, but do not blow away any other config
      file_line { '/etc/default/haproxy,ENABLED':
        ensure => 'present',
        path   => '/etc/default/haproxy',
        line   => 'ENABLED=1',
        match  => '^ENABLED=',
        before => Service['haproxy'],
      }
    }

    $_service_enable = $haproxy::_service_ensure ? {
      'running' => true,
      'stopped' => false,
      default   => $haproxy::_service_ensure,
    }

    service { 'haproxy':
      ensure     => $haproxy::_service_ensure,
      enable     => $_service_enable,
      name       => 'haproxy',
      hasrestart => true,
      hasstatus  => true,
      restart    => $haproxy::restart_command,
    }
  }
}
