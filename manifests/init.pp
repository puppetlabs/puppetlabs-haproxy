# == Class: haproxy
#
# A Puppet module, using storeconfigs, to model an haproxy configuration.
# Currently VERY limited - assumes Redhat/CentOS setup. Pull requests accepted!
#
# === Requirement/Dependencies:
#
# Currently requires the puppetlabs/concat module on the Puppet Forge and
#  uses storeconfigs on the Puppet Master to export/collect resources
#  from all balancer members.
#
# === Parameters
#
# [*package_ensure*]
#   Chooses whether the haproxy package should be installed or uninstalled.
#   Defaults to 'present'
#
# [*package_name*]
#   The package name of haproxy. Defaults to 'haproxy'
#   NOTE: haproxy::instance has a different default.
#
# [*service_ensure*]
#   Chooses whether the haproxy service should be running & enabled at boot, or
#   stopped and disabled at boot. Defaults to 'running'
#
# [*service_manage*]
#   Chooses whether the haproxy service state should be managed by puppet at
#   all. Defaults to true
#
# [*service_options*]
#   Contents for the `/etc/defaults/haproxy` file on Debian. Defaults to "ENABLED=1\n" on Debian, and is ignored on other systems.
#
# [*sysconfig_options*]
#   Contents for the `/etc/sysconfig/haproxy` file on RedHat(-based) systems. Defaults to OPTIONS="" on RedHat(-based) systems and is ignored on others
#
# [*global_options*]
#   A hash of all the haproxy global options. If you want to specify more
#    than one option (i.e. multiple timeout or stats options), pass those
#    options as an array and you will get a line for each of them in the
#    resultant haproxy.cfg file.
#
# [*defaults_options*]
#   A hash of all the haproxy defaults options. If you want to specify more
#    than one option (i.e. multiple timeout or stats options), pass those
#    options as an array and you will get a line for each of them in the
#    resultant haproxy.cfg file.
#
# [*merge_options*]
#   Whether to merge the user-supplied `global_options`/`defaults_options`
#   hashes with their default values set in params.pp. Merging allows to change
#   or add options without having to recreate the entire hash. Defaults to
#   false, but will default to true in future releases.
#
# [*restart_command*]
#   Command to use when restarting the on config changes.
#    Passed directly as the <code>'restart'</code> parameter to the service resource.
#    Defaults to undef i.e. whatever the service default is.
#
# [*custom_fragment*]
#   Allows arbitrary HAProxy configuration to be passed through to support
#   additional configuration not available via parameters, or to short-circute
#   the defined resources such as haproxy::listen when an operater would rather
#   just write plain configuration. Accepts a string (ie, output from the
#   template() function). Defaults to undef
#
# [*config_dir*]
#   Path to the directory in which the main configuration file `haproxy.cfg`
#   resides. Will also be used for storing any managed map files (see
#   `haproxy::mapfile`). Default depends on platform.
#
# === Examples
#
#  class { 'haproxy':
#    global_options   => {
#      'log'     => "${::ipaddress} local0",
#      'chroot'  => '/var/lib/haproxy',
#      'pidfile' => '/var/run/haproxy.pid',
#      'maxconn' => '4000',
#      'user'    => 'haproxy',
#      'group'   => 'haproxy',
#      'daemon'  => '',
#      'stats'   => 'socket /var/lib/haproxy/stats'
#    },
#    defaults_options => {
#      'log'     => 'global',
#      'stats'   => 'enable',
#      'option'  => 'redispatch',
#      'retries' => '3',
#      'timeout' => [
#        'http-request 10s',
#        'queue 1m',
#        'connect 10s',
#        'client 1m',
#        'server 1m',
#        'check 10s'
#      ],
#      'maxconn' => '8000'
#    },
#  }
#
class haproxy (
  $package_ensure    = 'present',
  $package_name      = $haproxy::params::package_name,
  $service_ensure    = 'running',
  $service_manage    = true,
  $service_options   = $haproxy::params::service_options,
  $sysconfig_options = $haproxy::params::sysconfig_options,
  $global_options    = $haproxy::params::global_options,
  $defaults_options  = $haproxy::params::defaults_options,
  $merge_options     = $haproxy::params::merge_options,
  $restart_command   = undef,
  $custom_fragment   = undef,
  $config_dir        = $haproxy::params::config_dir,
  $config_file       = $haproxy::params::config_file,
  $manage_config_dir = $haproxy::params::manage_config_dir,

  # Deprecated
  $manage_service   = undef,
  $enable           = undef,
) inherits haproxy::params {

  if $service_ensure != true and $service_ensure != false {
    if ! ($service_ensure in [ 'running','stopped']) {
      fail('service_ensure parameter must be running, stopped, true, or false')
    }
  }
  validate_string($package_name,$package_ensure)
  validate_bool($service_manage)
  validate_bool($merge_options)
  validate_string($service_options)
  validate_hash($global_options, $defaults_options)
  validate_absolute_path($config_dir)

  # NOTE: These deprecating parameters are implemented in this class,
  # not in haproxy::instance.  haproxy::instance is new and therefore
  # there should be no legacy code that uses these deprecated
  # parameters.

  # To support deprecating $enable
  if $enable != undef {
    warning('The $enable parameter is deprecated; please use service_ensure and/or package_ensure instead')
    if $enable {
      $_package_ensure = 'present'
      $_service_ensure = 'running'
    } else {
      $_package_ensure = 'absent'
      $_service_ensure = 'stopped'
    }
  } else {
    $_package_ensure = $package_ensure
    $_service_ensure = $service_ensure
  }

  # To support deprecating $manage_service
  if $manage_service != undef {
    warning('The $manage_service parameter is deprecated; please use $service_manage instead')
    $_service_manage = $manage_service
  } else {
    $_service_manage = $service_manage
  }

  haproxy::instance{ $title:
    package_ensure    => $_package_ensure,
    package_name      => $package_name,
    service_ensure    => $_service_ensure,
    service_manage    => $_service_manage,
    global_options    => $global_options,
    defaults_options  => $defaults_options,
    restart_command   => $restart_command,
    custom_fragment   => $custom_fragment,
    config_dir        => $config_dir,
    config_file       => $config_file,
    merge_options     => $merge_options,
    service_options   => $service_options,
    sysconfig_options => $sysconfig_options,
  }

}
