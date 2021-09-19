# @summary
#   This type will create a ring-buffer configuration block inside
#   the haproxy.cfg file on an haproxy load balancer.
#
# @note
#   Currently requires the puppetlabs/concat module on the Puppet Forge and
#   uses storeconfigs on the Puppet Server to export/collect resources
#   from all balancer members.
#
# @param section_name
#    This name goes right after the 'ring' statement in haproxy.cfg
#    Default: $name (the namevar of the resource).
#
# @param options
#   A hash of options that are inserted into the frontend service
#    configuration block.
#
# @param sort_options_alphabetic
#   Sort options either alphabetic or custom like haproxy internal sorts them.
#   Defaults to true.
#
# @param defaults
#   Name of the defaults section this backend will use.
#   Defaults to undef which means the global defaults section will be used.
#
#  haproxy::ring { 'puppet00':
#    ring_options => {
#     'log'                                    => [
#       'global',
#     ]
#     'server'    => 'log01.local 127.0.0.1:1510 log-proto octet-count',
#    },
#
# === Authors
#
# Erwin Dwight S. Paler <erwin.dwight.paler@gmail.com>
#
define haproxy::ring (
  $ring_options                                = {
    'description'                              => [
      'My local buffer',
    ],
  },
  $instance                                    = 'haproxy',
  $section_name                                = $name,
  Optional[Stdlib::Absolutepath] $config_file  = undef,
) {

  include ::haproxy::params

  if $instance == 'haproxy' {
    $instance_name = 'haproxy'
    $_config_file = pick($config_file, $haproxy::config_file)
  } else {
    $instance_name = "haproxy-${instance}"
    $_config_file = pick($config_file, inline_template($haproxy::params::config_file_tmpl))
  }

  include haproxy::globals
  $_sort_options_alphabetic = pick($sort_options_alphabetic, $haproxy::globals::sort_options_alphabetic)

  if $defaults == undef {
    $order = "15-${section_name}-00"
  } else {
    if $defaults_use_backend and has_key($options, 'default_backend') {
      $order = "25-${defaults}-${options['default_backend']}-00-${section_name}"
    } else {
      $order = "25-${defaults}-${section_name}-00"
    }
  }
  concat::fragment { "${instance_name}-${section_name}_log-forward-ring":
    order   => $order,
    target  => $_config_file,
    content => template('haproxy/haproxy_ring_block.erb'),
  }
}
