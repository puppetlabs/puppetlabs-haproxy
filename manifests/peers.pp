# == Defined Type: haproxy::peers
#
#  This type will set up a peers entry in haproxy.cfg
#   on the load balancer. This setting is required to share the
#   current state of HAproxy with other HAproxy in High available
#   configurations.
#
# === Parameters
#
# [*name*]
#  Sets the peers' name. Generally it will be the namevar of the
#   defined resource type. This value appears right after the
#   'peers' statement in haproxy.cfg
#
# [*config_file*]
#   Optional. Path of the config file where this entry will be added.
#   Assumes that the parent directory exists.
#   Default: $haproxy::params::config_file

define haproxy::peers (
  Boolean $collect_exported = true,
  String $instance = 'haproxy',
  Optional[Stdlib::Absolutepath] $config_file = undef,
) {

  # We derive these settings so that the caller only has to specify $instance.
  include ::haproxy::params

  if $instance == 'haproxy' {
    $instance_name = 'haproxy'
    $_config_file = pick($config_file, $haproxy::config_file)
  } else {
    $instance_name = "haproxy-${instance}"
    $_config_file = pick($config_file, inline_template($haproxy::params::config_file_tmpl))
  }

  # Template uses: $name
  concat::fragment { "${instance_name}-${name}_peers_block":
    order   => "30-peers-00-${name}",
    target  => $_config_file,
    content => template('haproxy/haproxy_peers_block.erb'),
  }

  if $collect_exported {
    haproxy::peer::collect_exported { $name: }
  }
  # else: the resources have been created and they introduced their
  # concat fragments. We don't have to do anything about them.
}
