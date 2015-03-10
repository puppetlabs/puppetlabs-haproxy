# Private class
define haproxy::config (
  $instance_name,
  $config_dir,
  $config_file,
  $global_options,
  $defaults_options,
  $custom_fragment,
) {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  if $config_dir != undef {
    file { $config_dir:
      ensure => directory,
      owner  => 'root',
      group  => 'root',
      mode   => '0755',  # TODO(tlim): Should be 0750?
    }
  }

  concat { $config_file:
    owner => '0',
    group => '0',
    mode  => '0644',
  }

  # Simple Header
  concat::fragment { "${instance_name}-00-header":
    target  => $config_file,
    order   => '01',
    content => "# This file managed by Puppet\n",
  }

  # Template uses $global_options, $defaults_options
  $_custom_fragment = $custom_fragment
  concat::fragment { "${instance_name}-haproxy-base":
    target  => $config_file,
    order   => '10',
    content => template('haproxy/haproxy-base.cfg.erb'),
  }

  if $global_options['chroot'] {
    ensure_resource('file', $global_options['chroot'], {
      ensure => directory,
      owner  => $global_options['user'],
      group  => $global_options['group'],
    })
  }
}
