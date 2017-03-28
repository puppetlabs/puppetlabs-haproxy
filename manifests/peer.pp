# == Define Resource Type: haproxy::peer
#
# This type will set up a peer entry inside the peers configuration block in
# haproxy.cfg on the load balancer. Currently, it has the ability to
# specify the instance name, ip address, ports and server_names.
#
# Automatic discovery of peer nodes may be implemented by exporting the peer resource
# for all HAProxy balancer servers that are configured in the same HA block and
# then collecting them on all load balancers.
#
# === Parameters:
#
# [*peers_name*]
#  Specifies the peer in which this load balancer needs to be added.
#
# [*server_names*]
#  Sets the name of the peer server in the peers configuration block.
#   Defaults to the hostname. Can be an array. If this parameter is
#   specified as an array, it must be the same length as the
#   ipaddresses parameter's array. A peer is created for each pair
#   of server\_names and ipaddresses in the array.
#
# [*ipaddresses*]
#  Specifies the IP address used to contact the peer member server.
#   Can be an array. If this parameter is specified as an array it
#   must be the same length as the server\_names parameter's array.
#   A peer is created for each pair of address and server_name.
#
# [*ports*]
#  Sets the port on which the peer is going to share the state.
#
# [*config_file*]
#   Optional. Path of the config file where this entry will be added.
#   Assumes that the parent directory exists.
#   Default: $haproxy::params::config_file

define haproxy::peer (
  $peers_name,
  $port,
  $server_names                               = $::hostname,
  $ipaddresses                                = $::ipaddress,
  $instance                                   = 'haproxy',
  Optional[Stdlib::Absolutepath] $config_file = undef,

) {
  include ::haproxy::params

  if $instance == 'haproxy' {
    $instance_name = 'haproxy'
    $_config_file = pick($config_file, $haproxy::config_file)
  } else {
    $instance_name = "haproxy-${instance}"
    $_config_file = pick($config_file, inline_template($haproxy::params::config_file_tmpl))
  }

  # Templates uses $ipaddresses, $server_name, $ports, $option
  concat::fragment { "${instance_name}-peers-${peers_name}-${name}":
    order   => "30-peers-01-${peers_name}-${name}",
    target  => $_config_file,
    content => template('haproxy/haproxy_peer.erb'),
  }
}
