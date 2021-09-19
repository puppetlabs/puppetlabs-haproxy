# @summary
#   This type will setup a Log forwarding service configuration block inside
#   the haproxy.cfg file on an haproxy load balancer.
#
# @note
#   Currently requires the puppetlabs/concat module on the Puppet Forge and
#   uses storeconfigs on the Puppet Server to export/collect resources
#   from all balancer members.
#
# @param section_name
#    This name goes right after the 'log-forward' statement in haproxy.cfg
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
# @param bind
#   Set of ip addresses, port and bind options
#   $bind = { '10.0.0.1:80' => ['ssl', 'crt', '/path/to/my/crt.pem'] }
#
# @param ipaddress
#   The ip address the proxy binds to.
#    Empty addresses, '*', and '0.0.0.0' mean that the proxy listens
#    to all valid addresses on the system.
#
# @param collect_exported
#   Boolean, default 'true'. True means 'collect exported @@balancermember resources'
#    (for the case when every balancermember node exports itself), false means
#    'rely on the existing declared balancermember resources' (for the case when you
#    know the full set of balancermembers in advance and use haproxy::balancermember
#    with array arguments, which allows you to deploy everything in 1 run)
#
#  haproxy::logforward { 'puppet00':
#    ipaddress    => $::ipaddress,
#    ports        => '514',
#    options      => {
#      'log'                                    => [
#        'global',
#      ]
#        'log' => 'log01.local:514 format rfc5424 sample 1:2 local7 info',
#    },
#  }
#
# === Authors
#
# Erwin Dwight S. Paler <erwin.dwight.paler@gmail.com>
#
define haproxy::logforward (
  $ports                                       = undef,
  $ipaddress                                   = undef,
  Optional[Hash] $dgram_bind                   = undef,
  Optional[Hash] $bind                         = undef,
  $options                                     = {
    'log'                                      => [
      'global',
    ],
  },
  $collect_exported                            = true,
  $instance                                    = 'haproxy',
  $section_name                                = $name,
  Optional[Stdlib::Absolutepath] $config_file  = undef,
) {
  if $ports and $bind {
    fail('The use of $ports and $bind is mutually exclusive, please choose either one')
  }
  if $ipaddress and $bind {
    fail('The use of $ipaddress and $bind is mutually exclusive, please choose either one')
  }

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
  # Template uses: $section_name, $ipaddress, $ports, $options
  concat::fragment { "${instance_name}-${section_name}_log-forward_block":
    order   => $order,
    target  => $_config_file,
    content => template('haproxy/haproxy_log-forward_block.erb'),
  }

  if $collect_exported {
    haproxy::balancermember::collect_exported { $section_name: }
  }
  # else: the resources have been created and they introduced their
  # concat fragments. We don't have to do anything about them.
}
