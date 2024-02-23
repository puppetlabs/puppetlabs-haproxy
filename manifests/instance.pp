# @summary
#   Manages haproxy permitting multiple instances to run on the same machine.
#   
# @note
#   Normally users use the Class['haproxy'], which runs a single haproxy
#   daemon on a machine.
#
# @note
#   Currently requires the puppetlabs/concat module on the Puppet Forge and
#   uses storeconfigs on the Puppet Server to export/collect resources
#   from all balancer members.
#
#
# @param package_ensure
#   Ensure the package is present (installed), absent or a specific version.
#   Defaults to 'present'
#
# @param package_name
#   The package name of haproxy. Defaults to undef, and no package is installed.
#   NOTE: Class['haproxy'] has a different default.
#
# @param install_options
#   Array of arguments passed to the installer
#
# @param service_ensure
#   Chooses whether the haproxy service should be running & enabled at boot, or
#   stopped and disabled at boot. Defaults to 'running'
#
# @param service_manage
#   Chooses whether the haproxy service state should be managed by puppet at
#   all. Defaults to true
#
# @param chroot_dir_manage
#   Chooses whether the haproxy chroot directory should be managed by puppet
#   at all. Defaults to true
#
# @param service_name
#   The service name for haproxy. Defaults to undef. If no name is given then
#   the value computed for $instance_name will be used.
#   NOTE: Class['haproxy'] has a different default.
#
# @param global_options
#   A hash of all the haproxy global options. If you want to specify more
#    than one option (i.e. multiple timeout or stats options), pass those
#    options as an array and you will get a line for each of them in the
#    resultant haproxy.cfg file.
#
# @param defaults_options
#   A hash of all the haproxy defaults options. If you want to specify more
#    than one option (i.e. multiple timeout or stats options), pass those
#    options as an array and you will get a line for each of them in the
#    resultant haproxy.cfg file.
#
# @param restart_command
#   Command to use when restarting the on config changes.
#    Passed directly as the <code>'restart'</code> parameter to the service
#    resource.  #    Defaults to undef i.e. whatever the service default is.
#
# @param custom_fragment
#   Allows arbitrary HAProxy configuration to be passed through to support
#   additional configuration not available via parameters, or to short-circuit
#   the defined resources such as haproxy::listen when an operater would rather
#   just write plain configuration. Accepts a string (ie, output from the
#  template() function). Defaults to undef
#
# @param config_file
#   Allows arbitrary config filename to be specified. If this is used,
#   it is assumed that the directory path to the file exists and has
#   owner/group/permissions as desired.  If set to undef, the name
#   will be generated as follows:
#     If $title is 'haproxy', the operating system default will be used.
#     Otherwise, /etc/haproxy-$title/haproxy-$title.conf (Linux),
#     or /usr/local/etc/haproxy-$title/haproxy-$title.conf (FreeBSD)
#     The parent directory will be created automatically.
#   Defaults to undef.
#
# @param config_validate_cmd
#   Command used by concat validate_cmd to validate new
#   config file concat is a valid haproxy config.
#   Default /usr/sbin/haproxy -f % -c
#
# @param config_dir
#   Optional. Default undef.
#
# @param merge_options
#
# @param service_options
#
# @param sysconfig_options
#
# @example
#  A single instance of haproxy with all defaults
#  i.e. emulate Class['haproxy']
#   package{ 'haproxy': ensure => present }->haproxy::instance { 'haproxy': }->
#   haproxy::listen { 'puppet00':
#     instance         => 'haproxy',
#     collect_exported => false,
#     ipaddress        => $::ipaddress,
#     ports            => '8140',
#   }
#
# @example
#  Multiple instances of haproxy:
#   haproxy::instance { 'group1': }
#   haproxy::instance_service { 'group1':
#     haproxy_init_source => "puppet:///modules/${module_name}/haproxy-group1.init",
#   }
#   haproxy::listen { 'puppet00':
#     instance         => 'group1',
#     collect_exported => false,
#     ipaddress        => $::ipaddress,
#     ports            => '8800',
#     requires         => Package['haproxy'],
#   }
#   haproxy::instance { 'group2': }
#   haproxy::instance_service { 'group2':
#     haproxy_init_source => "puppet:///modules/${module_name}/haproxy-group1.init",
#   }
#   haproxy::listen { 'puppet00':
#     instance         => 'group2',
#     collect_exported => false,
#     ipaddress        => $::ipaddress,
#     ports            => '9900',
#     requires         => Package['haproxy'],
#   }
#
# @example
#  Multiple instances of haproxy, one with a custom haproxy package:
#   haproxy::instance { 'group1': }
#   haproxy::instance_service { 'group1':
#     haproxy_init_source => "puppet:///modules/${module_name}/haproxy-group1.init",
#   }
#   haproxy::listen { 'puppet00':
#     instance         => 'group1',
#     collect_exported => false,
#     ipaddress        => $::ipaddress,
#     ports            => '8800',
#     requires         => Package['haproxy'],
#   }
#   haproxy::instance { 'group2': }
#   haproxy::instance_service { 'group2':
#     haproxy_package     => 'custom_haproxy',
#     haproxy_init_source => "puppet:///modules/${module_name}/haproxy-group2.init",
#   }
#   haproxy::listen { 'puppet00':
#     instance         => 'group2',
#     collect_exported => false,
#     ipaddress        => $::ipaddress,
#     ports            => '9900',
#     requires         => Package['haproxy'],
#   }
#
# @note
#   When running multiple instances on one host, there must be a Service[] for
#   each instance.  One way to create the situation where Service[] works is
#   using haproxy::instance_service.
#   However you may want to do it some other way. For example, you may
#   not have packages for your custom haproxy binary. Or, you may wish
#   to use the standard haproxy package but not create links to it, or
#   you may have different init.d scripts.  In these cases, write your own
#   puppet code that will result in Service[] working for you and do not
#   call haproxy::instance_service.
#
define haproxy::instance (
  Variant[Enum['present', 'absent', 'purged', 'disabled', 'installed', 'latest'], String[1]] $package_ensure = 'present',
  Optional[String]                             $package_name         = undef,
  Array[String[1]]                             $install_options      = [],
  Variant[Enum['running', 'stopped'], Boolean] $service_ensure       = 'running',
  Boolean                                      $service_manage       = true,
  Boolean                                      $chroot_dir_manage    = true,
  Optional[String]                             $service_name         = undef,
  Optional[Hash]                               $global_options       = undef,
  Optional[Hash]                               $defaults_options     = undef,
  Optional[String]                             $restart_command      = undef,
  Optional[String]                             $custom_fragment      = undef,
  Optional[Stdlib::Absolutepath]               $config_dir           = undef,
  Optional[Stdlib::Absolutepath]               $config_file          = undef,
  Variant[Stdlib::Absolutepath, String]        $config_validate_cmd  = $haproxy::params::config_validate_cmd,
  Boolean                                      $merge_options        = $haproxy::params::merge_options,
  String                                       $service_options      = $haproxy::params::service_options,
  String                                       $sysconfig_options    = $haproxy::params::sysconfig_options,
) {
  # Since this is a 'define', we can not use 'inherts haproxy::params'.
  # Therefore, we "include haproxy::params" for any parameters we need.
  contain haproxy::params

  $_global_options = pick($global_options, $haproxy::params::global_options)
  $_defaults_options = pick($defaults_options, $haproxy::params::defaults_options)

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
  if $instance_name == 'haproxy' {
    $_config_file = pick($config_file, $haproxy::params::config_file)
  } else {
    $_config_file = pick($config_file, inline_template($haproxy::params::config_file_tmpl))
  }

  if $instance_name == 'haproxy' {
    $_config_dir = pick($config_dir, $haproxy::params::config_dir)
  } else {
    $_config_dir = pick($config_dir, inline_template($haproxy::params::config_dir_tmpl))
  }

  $instance_service_name = pick($service_name, $instance_name)

  haproxy::config { $title:
    instance_name       => $instance_name,
    config_dir          => $_config_dir,
    config_file         => $_config_file,
    global_options      => $_global_options,
    defaults_options    => $_defaults_options,
    custom_fragment     => $custom_fragment,
    merge_options       => $merge_options,
    package_ensure      => $package_ensure,
    chroot_dir_manage   => $chroot_dir_manage,
    config_validate_cmd => $config_validate_cmd,
  }
  haproxy::install { $title:
    package_name    => $package_name,
    package_ensure  => $package_ensure,
    install_options => $install_options,
  }
  haproxy::service { $title:
    instance_name     => $instance_service_name,
    service_ensure    => $service_ensure,
    service_manage    => $service_manage,
    restart_command   => $restart_command,
    service_options   => $service_options,
    sysconfig_options => $sysconfig_options,
  }

  if $package_ensure == 'absent' or $package_ensure == 'purged' {
    Haproxy::Service[$title]
    -> Haproxy::Config[$title]
    -> Haproxy::Install[$title]
  } else {
    Haproxy::Install[$title]
    -> Haproxy::Config[$title]
    ~> Haproxy::Service[$title]
  }
}
