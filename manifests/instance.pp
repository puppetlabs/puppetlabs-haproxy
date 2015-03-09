# == Define Resource Type: haproxy::instance
#
# Manages haproxy permitting multiple instances to run on the same machine.
# Normally users use the Class['haproxy'], which runs a single haproxy
# daemon on a machine.
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
#   The package name of haproxy. Defaults to undef, and no package is installed.
#   NOTE: Class['haproxy'] has a different default.
#
# [*service_ensure*]
#   Chooses whether the haproxy service should be running & enabled at boot, or
#   stopped and disabled at boot. Defaults to 'running'
#
# [*service_manage*]
#   Chooses whether the haproxy service state should be managed by puppet at
#   all. Defaults to true
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
#[*restart_command*]
#   Command to use when restarting the on config changes.
#    Passed directly as the <code>'restart'</code> parameter to the service
#    resource.  #    Defaults to undef i.e. whatever the service default is.
#
#[*custom_fragment*]
#  Allows arbitrary HAProxy configuration to be passed through to support
#  additional configuration not available via parameters, or to short-circut
#  the defined resources such as haproxy::listen when an operater would rather
#  just write plain configuration. Accepts a string (ie, output from the
#  template() function). Defaults to undef
#
#[*config_file*]
#  Allows arbitrary config filename to be specified. If this is used,
#  it is assumed that the directory path to the file exists and has
#  owner/group/permissions as desired.  If set to undef, the name
#  will be generated as follows:
#    If $title is 'haproxy', the operating system default will be used.
#    Otherwise, /etc/haproxy-$title/haproxy-$title.conf (Linux),
#    or /usr/local/etc/haproxy-$title/haproxy-$title.conf (FreeBSD)
#    The parent directory will be created automatically.
#  Defaults to undef.
#
# === Examples
#
# A single instance of haproxy with all defaults
# i.e. emulate Class['haproxy']
#   package{ 'haproxy': ensure => present }->haproxy::instance { 'haproxy': }->
#   haproxy::listen { 'puppet00':
#     instance         => 'haproxy',
#     collect_exported => false,
#     ipaddress        => $::ipaddress,
#     ports            => '8140',
#   }
#
# Multiple instances of haproxy:
#   haproxy::instance { 'group1': }
#   haproxy::instance_service { 'group1': }
#   haproxy::listen { 'puppet00':
#     instance         => 'group1',
#     collect_exported => false,
#     ipaddress        => $::ipaddress,
#     ports            => '8800',
#     requires         => Package['haproxy'],
#   }
#   haproxy::instance { 'group2': }
#   haproxy::instance_service { 'group2': }
#   haproxy::listen { 'puppet00':
#     instance         => 'group2',
#     collect_exported => false,
#     ipaddress        => $::ipaddress,
#     ports            => '9900',
#     requires         => Package['haproxy'],
#   }
#
# Multiple instances of haproxy, one with a custom haproxy package:
#   haproxy::instance { 'group1': }
#   haproxy::instance_service { 'group1': }
#   haproxy::listen { 'puppet00':
#     instance         => 'group1',
#     collect_exported => false,
#     ipaddress        => $::ipaddress,
#     ports            => '8800',
#     requires         => Package['haproxy'],
#   }
#   haproxy::instance { 'group2': }
#   haproxy::instance_service { 'group2': 'custom_haproxy' }
#   haproxy::listen { 'puppet00':
#     instance         => 'group2',
#     collect_exported => false,
#     ipaddress        => $::ipaddress,
#     ports            => '9900',
#     requires         => Package['haproxy'],
#   }
#
#  When running multiple instances on one host, there must be a Service[] for
#  each instance.  One way to create the situation where Service[] works is
#  using haproxy::instance_service.
#  However you may want to do it some other way. For example, you may
#  not have packages for your custom haproxy binary. Or, you may wish
#  to use the standard haproxy package but not create links to it, or
#  you may have different init.d scripts.  In these cases, write your own
#  puppet code that will result in Service[] working for you and do not
#  call haproxy::instance_service.
#
define haproxy::instance (
  $package_ensure   = 'present',
  $package_name     = undef,
  $service_ensure   = 'running',
  $service_manage   = true,
  $global_options   = undef,
  $defaults_options = undef,
  $restart_command  = undef,
  $custom_fragment  = undef,
  $config_file      = undef,
) {

  if $service_ensure != true and $service_ensure != false {
    if ! ($service_ensure in [ 'running','stopped']) {
      fail('service_ensure parameter must be running, stopped, true, or false')
    }
  }
  validate_string($package_name,$package_ensure)
  validate_bool($service_manage)

  # Since this is a 'define', we can not use 'inherts haproxy::params'.
  # Therefore, we "include haproxy::params" for any parameters we need.
  if $global_options == undef {
    include haproxy::params
    $_global_options = $haproxy::params::global_options
  } else {
    $_global_options = $global_options
  }
  if $defaults_options == undef {
    include haproxy::params
    $_defaults_options = $haproxy::params::defaults_options
  } else {
    $_defaults_options = $defaults_options
  }

  # Determine instance_name based on:
  #   single-instance hosts: haproxy
  #   multi-instance hosts:  haproxy-$title
  if $title == 'haproxy' {
    $instance_name = 'haproxy'
  } else {
    $instance_name = "haproxy-${title}"
  }

  # Determine config_dir and config_file:
  #   If config_dir defined, use it.  Otherwise:
  #   single-instance hosts: use defaults
  #   multi-instance hosts:  use templates
  if $config_file != undef {
    $_config_dir = undef
    $_config_file = $config_file
  } else {
    include haproxy::params
    if $instance_name == 'haproxy' {
      $_config_dir = $haproxy::params::config_dir
      $_config_file = $haproxy::params::config_file
    } else {
      $_config_dir = inline_template($haproxy::params::config_dir_tmpl)
      $_config_file = inline_template($haproxy::params::config_file_tmpl)
    }
  }

  $_custom_fragment = $custom_fragment

  haproxy::config { $title:
    instance_name    => $instance_name,
    config_dir       => $_config_dir,
    config_file      => $_config_file,
    global_options   => $_global_options,
    defaults_options => $_defaults_options,
    custom_fragment  => $_custom_fragment,
  }
  haproxy::install { $title:
    package_name   => $package_name,
    package_ensure => $package_ensure,
  }
  haproxy::service { $title:
    instance_name   => $instance_name,
    service_ensure  => $service_ensure,
    service_manage  => $service_manage,
    restart_command => $restart_command,
  }

  if $package_ensure == 'absent' or $package_ensure == 'purged' {
    anchor { "${title}::haproxy::begin": }
    ~> Haproxy::Service[$title]
    -> Haproxy::Config[$title]
    -> Haproxy::Install[$title]
    -> anchor { "${title}::haproxy::end": }
  } else {
    anchor { "${title}::haproxy::begin": }
    -> Haproxy::Install[$title]
    -> Haproxy::Config[$title]
    ~> Haproxy::Service[$title]
    -> anchor { "${title}::haproxy::end": }
  }
}
