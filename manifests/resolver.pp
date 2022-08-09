# @summary
#  This type will setup resolvers configuration block inside
#  the haproxy.cfg file on an haproxy load balancer.
#
# @note
#  Currently requires the puppetlabs/concat module on the Puppet Forge and
#  uses storeconfigs on the Puppet Server to export/collect resources
#  from all balancer members.
#
#
# @param section_name
#    This name goes right after the 'resolvers' statement in haproxy.cfg
#    Default: $name (the namevar of the resource).
#
# @param nameservers
#   Set of id, ip addresses and port options.
#   $nameservers = { 'dns1' => '10.0.0.1:53', 'dns2' => '10.0.0.2:53' }
#
# @param hold
#   Defines <period> during which the last name resolution should be kept
#     based on last valid resolution status.
#   $hold = { 'nx' => '30s', 'valid' => '10s' }
#
# @param resolve_retries
#   Defines the number <nb> of queries to send to resolve a server name before
#    giving up.
#   $resolve_retries = 3
#
# @param timeout
#   Defines timeouts related to name resolution in the listening serivce's
#    configuration block.
#   $timeout = { 'retry' => '1s' }
#
# @param accepted_payload_size
#   Defines the maximum payload size accepted by HAProxy and announced to all the
#   name servers configured in this resolvers section.
#   <nb> is in bytes. If not set, HAProxy announces 512. (minimal value defined
#   by RFC 6891)
#   Note: the maximum allowed value is 8192.
#
# @param collect_exported
#   Boolean, default 'true'. True means 'collect exported @@balancermember
#    resources' (for the case when every balancermember node exports itself),
#    false means 'rely on the existing declared balancermember resources' (for
#    the case when you know the full set of balancermember in advance and use
#    haproxy::balancermember with array arguments, which allows you to deploy
#    everything in 1 run)
#
# @param config_file
#   Optional. Path of the config file where this entry will be added.
#   Assumes that the parent directory exists.
#   Default: $haproxy::params::config_file
#
# @param sort_options_alphabetic
#   Sort options either alphabetic or custom like haproxy internal sorts them.
#   Defaults to true.
#
# @param defaults
#   Name of the defaults section this backend will use.
#   Defaults to undef which means the global defaults section will be used.
# 
# @param instance
#   Optional. Defaults to 'haproxy'
#
# @example
#  Exporting the resource for a balancer member:
#
#  haproxy::resolver { 'puppet00':
#    nameservers           => {
#      'dns1' => '10.0.0.1:53',
#      'dns2' => '10.0.0.2:53'
#    },
#    hold                  => {
#      'nx'    => '30s',
#      'valid' => '10s'
#    },
#    resolve_retries       => 3,
#    timeout               => {
#      'retry' => '1s'
#    },
#    accepted_payload_size => 512,
#  }
#
# === Authors
#
# Gary Larizza <gary@puppetlabs.com>
# Ricardo Rosales <missingcharacter@gmail.com>
#
define haproxy::resolver (
  $nameservers             = undef,
  $hold                    = undef,
  $resolve_retries         = undef,
  $timeout                 = undef,
  # https://cbonte.github.io/haproxy-dconv/1.8/configuration.html#5.3.2-accepted_payload_size
  Optional[Integer[512, 8192]] $accepted_payload_size = undef,
  $instance                = 'haproxy',
  $section_name            = $name,
  $sort_options_alphabetic = undef,
  $collect_exported        = true,
  $config_file             = undef,
  $defaults                = undef,
) {
  include haproxy::params

  if $instance == 'haproxy' {
    $instance_name = 'haproxy'
    $_config_file  = pick($config_file, $haproxy::config_file)
  } else {
    $instance_name = "haproxy-${instance}"
    $_config_file  = pick($config_file, inline_template($haproxy::params::config_file_tmpl))
  }

  assert_type(Stdlib::AbsolutePath, dirname($_config_file))

  include haproxy::globals
  $_sort_options_alphabetic = pick($sort_options_alphabetic, $haproxy::globals::sort_options_alphabetic)

  if $defaults == undef {
    $order = "20-${section_name}-01"
  } else {
    $order = "25-${defaults}-${section_name}-02"
  }

  # Template uses: $section_name
  concat::fragment { "${instance_name}-${section_name}_resolver_block":
    order   => $order,
    target  => $_config_file,
    content => template('haproxy/haproxy_resolver_block.erb'),
  }

  if $collect_exported {
    haproxy::balancermember::collect_exported { $section_name: }
  }
  # else: the resources have been created and they introduced their
  # concat fragments. We don't have to do anything about them.
}
