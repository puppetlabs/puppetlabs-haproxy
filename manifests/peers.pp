#
define haproxy::peers (
  $collect_exported = true,
  $instance = 'haproxy',
) {

  # We derive these settings so that the caller only has to specify $instance.
  include haproxy::params
  if $instance == 'haproxy' {
    $instance_name = 'haproxy'
    #$config_dir = $haproxy::params::config_dir
    $config_file = $haproxy::params::config_file
  } else {
    $instance_name = "haproxy-${instance}"
    #$config_dir = inline_template($haproxy::params::config_dir_tmpl)
    $config_file = inline_template($haproxy::params::config_file_tmpl)
  }

  # Template uses: $name, $ipaddress, $ports, $options
  concat::fragment { "${instance_name}-${name}_peers_block":
    order   => "30-peers-00-${name}",
    target  => $config_file,
    content => template('haproxy/haproxy_peers_block.erb'),
  }

  if $collect_exported {
    haproxy::peer::collect_exported { $name: }
  }
  # else: the resources have been created and they introduced their
  # concat fragments. We don't have to do anything about them.
}
