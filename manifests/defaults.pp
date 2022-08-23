# @summary
#  This type will setup a defaults configuration block inside the haproxy.cfg
#  file on an haproxy load balancer.
#
# @note
#  The hash 'defaults_options' will be used as last defaults block below any optional other named default blocks.
#  The define 'haproxy::defaults' can be used to add named default configuration blocks.
#  A named default configuration block resets all defaults of prior defaults configuration blocks.
#  Listener, Backends, Frontends and Balancermember can inherit a default
#  configuration block by setting the defaults parameter to the corresponding
#  defaults name.
#
# @param defaults_options
#   A hash of options that are inserted into the defaults configuration block.
#
# @param merge_options
#   Whether to merge the user-supplied options hash with their default
#   values set in params.pp. Effects only the 'unnamed' defaults section.
#   Merging allows to change or add options without having to recreate
#   the entire hash. Defaults to false, but will default to true in future releases.
#
# @param sort_options_alphabetic
#   Sort options either alphabetic or custom like haproxy internal sorts them.
#   Defaults to true.
#
# @param instance
#   Optional. Defaults to 'haproxy'.
#
define haproxy::defaults (
  Boolean $merge_options                           = $haproxy::merge_options,
  Hash $defaults_options                           = {},
  String $instance                                 = 'haproxy',
  Variant[Undef, Boolean] $sort_options_alphabetic = undef,
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

  if $name == 'haproxy' { # when called from haproxy::instance
    if $merge_options {
      $options = merge($haproxy::params::defaults_options, $defaults_options)
    } else {
      $options = $defaults_options
      warning("${module_name}: The \$merge_options parameter will default to true in the next major release. Please review the documentation regarding the implications.") # lint:ignore:140chars
    }
  } else {
    $options = $defaults_options
  }

  concat::fragment { "${instance_name}-${name}_defaults_block":
    order   => '12',
    target  => $config_file,
    content => template('haproxy/haproxy_defaults_block.erb'),
  }
}
