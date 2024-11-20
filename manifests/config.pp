# @summary
#   HAProxy configuration
# @api private
define haproxy::config (
  # lint:ignore:140chars
  Variant[Enum['present', 'absent', 'purged', 'disabled', 'installed', 'latest'], String[1]] $package_ensure,
  String                                $instance_name,
  Stdlib::Absolutepath                  $config_file,
  Hash                                  $global_options,
  Hash                                  $defaults_options,
  Boolean                               $chroot_dir_manage,
  Stdlib::Absolutepath                  $config_dir          = undef,
  Optional[String]                      $custom_fragment     = undef,
  Boolean                               $merge_options       = $haproxy::merge_options,
  Variant[Stdlib::Absolutepath, String] $config_validate_cmd = $haproxy::config_validate_cmd,
  # lint:endignore
) {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  if $merge_options {
    $_global_options   = $haproxy::params::global_options + $global_options
    $_defaults_options = $haproxy::params::defaults_options + $defaults_options
  } else {
    $_global_options   = $global_options
    $_defaults_options = $defaults_options
  }

  if defined(Class['haproxy']) {
    $manage_config_dir = $haproxy::manage_config_dir
  } else {
    $manage_config_dir = $haproxy::params::manage_config_dir
  }
  if $manage_config_dir {
    if $config_dir != undef {
      file { $config_dir:
        ensure => directory,
        owner  => '0',
        group  => '0',
        mode   => '0755',
      }
    }
  }

  if $config_file != undef {
    $_config_file = $config_file
  } else {
    $_config_file = $haproxy::config_file
  }

  if $package_ensure == 'absent' {
    file { $_config_file: ensure => absent }
  } else {
    concat { $_config_file:
      owner => '0',
      group => '0',
      mode  => '0640',
      tag   => 'haproxy-config',
    }

    Concat[$_config_file] {
      validate_cmd => $config_validate_cmd,
    }

    # Simple Header
    concat::fragment { "${instance_name}-00-header":
      target  => $_config_file,
      order   => '01',
      content => "# This file is managed by Puppet\n",
    }

    $parameters = {
      '_global_options'   => $_global_options,
      '_defaults_options' => $_defaults_options,
      'custom_fragment'   => $custom_fragment,
    }

    # Template uses $_global_options, $_defaults_options, $custom_fragment
    concat::fragment { "${instance_name}-haproxy-base":
      target  => $_config_file,
      order   => '10',
      content => epp("${module_name}/haproxy-base.cfg.epp", $parameters),
    }
  }

  if $chroot_dir_manage {
    if $_global_options['chroot'] {
      file { $_global_options['chroot']:
        ensure => directory,
        owner  => $_global_options['user'],
        group  => $_global_options['group'],
      }
    }
  }
}
