# == Define Resource Type: haproxy::frontend
#
# This type will setup a frontend service configuration block inside
#  the haproxy.cfg file on an haproxy load balancer.
#
# === Requirement/Dependencies:
#
# Currently requires the puppetlabs/concat module on the Puppet Forge and
#  uses storeconfigs on the Puppet Master to export/collect resources
#  from all balancer members.
#
# === Parameters
#
# [*section_name*]
#    This name goes right after the 'frontend' statement in haproxy.cfg
#    Default: $name (the namevar of the resource).
#
# [*ports*]
#   Ports on which the proxy will listen for connections on the ip address
#    specified in the ipaddress parameter. Accepts either a single
#    comma-separated string or an array of strings which may be ports or
#    hyphenated port ranges.
#
# [*bind*]
#   Set of ip addresses, port and bind options
#   $bind = { '10.0.0.1:80' => ['ssl', 'crt', '/path/to/my/crt.pem'] }
#
# [*ipaddress*]
#   The ip address the proxy binds to.
#    Empty addresses, '*', and '0.0.0.0' mean that the proxy listens
#    to all valid addresses on the system.
#
# [*mode*]
#   The mode of operation for the frontend service. Valid values are undef,
#    'tcp', 'http', and 'health'.
#
# [*bind_options*]
#   (Deprecated) An array of options to be specified after the bind declaration
#    in the listening serivce's configuration block.
#
# [*options*]
#   A hash of options that are inserted into the frontend service
#    configuration block.
#
# [*sort_options_alphabetic*]
#   Sort options either alphabetic or custom like haproxy internal sorts them.
#   Defaults to true.
#
# [*defaults*]
#   Name of the defaults section this backend will use.
#   Defaults to undef which means the global defaults section will be used.
#
# [*defaults_use_backend*]
#   If defaults are used and a default backend is configured use the backend
#   name for ordering. This means that the frontend is placed in the 
#   configuration file before the backend configuration.
#   Defaults to true.
#
# [*config_file*]
#   Optional. Path of the config file where this entry will be added.
#   Assumes that the parent directory exists.
#   Default: $haproxy::params::config_file
#
# === Examples
#
#  Exporting the resource for a balancer member:
#
#  haproxy::frontend { 'puppet00':
#    ipaddress    => $::ipaddress,
#    ports        => '18140',
#    mode         => 'tcp',
#    bind_options => 'accept-proxy',
#    options      => {
#      'option'   => [
#        'tcplog',
#        'accept-invalid-http-request',
#      ],
#      'timeout client' => '30s',
#      'balance'    => 'roundrobin'
#    },
#  }
#
# === Authors
#
# Gary Larizza <gary@puppetlabs.com>
#
define haproxy::frontend (
  $ports                   = undef,
  $ipaddress               = undef,
  $bind                    = undef,
  $mode                    = undef,
  $collect_exported        = true,
  $options                 = {
    'option'  => [
      'tcplog',
    ],
  },
  $instance                = 'haproxy',
  $section_name            = $name,
  $sort_options_alphabetic = undef,
  $defaults                = undef,
  $defaults_use_backend    = true,
  $config_file             = undef,
  # Deprecated
  $bind_options            = undef,
) {
  if $ports and $bind {
    fail('The use of $ports and $bind is mutually exclusive, please choose either one')
  }
  if $ipaddress and $bind {
    fail('The use of $ipaddress and $bind is mutually exclusive, please choose either one')
  }
  if $bind_options {
    warning('The $bind_options parameter is deprecated; please use $bind instead')
  }
  if $bind {
    validate_hash($bind)
  }

  include haproxy::params

  if $instance == 'haproxy' {
    $instance_name = 'haproxy'
    $_config_file = pick($config_file, $haproxy::config_file)
  } else {
    $instance_name = "haproxy-${instance}"
    $_config_file = pick($config_file, inline_template($haproxy::params::config_file_tmpl))
  }

  validate_absolute_path(dirname($_config_file))

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
  concat::fragment { "${instance_name}-${section_name}_frontend_block":
    order   => $order,
    target  => $_config_file,
    content => template('haproxy/haproxy_frontend_block.erb'),
  }
}
