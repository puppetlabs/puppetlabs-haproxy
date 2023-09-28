# @summary
#  This type will setup a additional defaults configuration block inside the
#  haproxy.cfg file on an haproxy load balancer. 
#
# @note
#  A new default configuration block resets all defaults of prior defaults configuration blocks.
#  Listener, Backends, Frontends and Balancermember can be configured behind a default
#  configuration block by setting the defaults parameter to the corresponding
#  defaults name.
#
#
# @param options
#   A hash of options that are inserted into the defaults configuration block.
#
# @param sort_options_alphabetic
#   Sort options either alphabetic or custom like haproxy internal sorts them.
#   Defaults to true.
#
# @param instance
#   Optional. Defaults to 'haproxy'.
#
define haproxy::defaults (
  Hash    $options                  = {},
  Optional[Boolean] $sort_options_alphabetic  = undef,
  String  $instance                 = 'haproxy',
) {
  if $instance == 'haproxy' {
    include haproxy
    $instance_name = 'haproxy'
    $config_file = $haproxy::config_file
  } else {
    include haproxy::params
    $instance_name = "haproxy-${instance}"
    $config_file = inline_template($haproxy::params::config_file_tmpl)
  }
  include haproxy::globals
  $_sort_options_alphabetic = pick($sort_options_alphabetic, $haproxy::globals::sort_options_alphabetic)

  $parameters = {
    '_sort_options_alphabetic' => $_sort_options_alphabetic,
    'options'                  => $options,
    'name'                     => $name,
  }

  concat::fragment { "${instance_name}-${name}_defaults_block":
    order   => "25-${name}",
    target  => $config_file,
    content => epp('haproxy/haproxy_defaults_block.epp', $parameters),
  }
}
