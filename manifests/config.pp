# Private class
define haproxy::config (
  $instance_name,
  $config_file,
  $global_options,
  $defaults_options,
  $config_dir = undef,  # A default is required for Puppet 2.7 compatibility. When 2.7 is no longer supported, this parameter default should be removed.
  $custom_fragment = undef,  # A default is required for Puppet 2.7 compatibility. When 2.7 is no longer supported, this parameter default should be removed.
  $merge_options = $haproxy::merge_options,
  $config_validate = $haproxy::config_validate,
  $config_validate_path = $haproxy::config_validate_path,
) {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  if $merge_options {
    $_global_options   = merge($haproxy::params::global_options, $global_options)
    $_defaults_options = merge($haproxy::params::defaults_options, $defaults_options)
  } else {
    $_global_options   = $global_options
    $_defaults_options = $defaults_options
    warning("${module_name}: The \$merge_options parameter will default to true in the next major release. Please review the documentation regarding the implications.")
  }

  if $config_dir != undef {
    file { $config_dir:
      ensure => directory,
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
    }
  }

  if $config_file != undef {
    $_config_file = $config_file
  } else {
    $_config_file = $haproxy::config_file
  }


  if $config_validate and $config_validate_path != undef {
    concat { $_config_file:
      owner        => '0',
      group        => '0',
      mode         => '0644',
      validate_cmd => $config_validate_path,
    }
  } else {
    concat { $_config_file:
      owner        => '0',
      group        => '0',
      mode         => '0644',
    }
  }

  # Simple Header
  concat::fragment { "${instance_name}-00-header":
    target  => $_config_file,
    order   => '01',
    content => "# This file managed by Puppet\n",
  }

  # Template uses $_global_options, $_defaults_options, $custom_fragment
  concat::fragment { "${instance_name}-haproxy-base":
    target  => $_config_file,
    order   => '10',
    content => template("${module_name}/haproxy-base.cfg.erb"),
  }

  if $_global_options['chroot'] {
    file { $_global_options['chroot']:
      ensure => directory,
      owner  => $_global_options['user'],
      group  => $_global_options['group'],
    }
  }
}
