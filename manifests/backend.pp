# == Define Resource Type: haproxy::backend
#
# This type will setup a standalone backend block in /etc/haproxy/haproxy.cfg
#  that can then be referenced by a listen or frontend block.
#
# === Requirement/Dependencies:
#
# Currently requires the ripienaar/concat module on the Puppet Forge and
#  uses storeconfigs on the Puppet Master to export/collect resources
#  from all balancer members.
#
# === Parameters
#
# [*name*]
#   The title of the resource is arbitrary and only utilized in the concat
#    fragment name.
#
# [*ports*]
#     An array or commas-separated list of ports for which the backend server
#     will accept connections from the load balancer. If you use an array
#     in server_names and ipaddresses, the same port is used for all backend
#     servers.
#
# [*server_names*]
#     The name of the backend server as known to haproxy in the
#      listening service's configuration block. This defaults to the
#      hostname. Can be an array of the same length as ipaddresses,
#      in which case a balancermember is created for each pair of
#      server_names and ipaddresses (in lockstep).
#
# [*ipaddresses*]
#     The ip address used to contact the backend server.
#      Can be an array. If this option is omitted, $server_names will 
#      be used
#
# [*options*]
#      An array of options to be specified inside the backend
#       configuration block.
#
# [*server_options*]
#      An array of options to be specified after the server declaration
#       in the backend configuration block.
#
# === Examples
#
#  Define a backend for a set of servers:
#
#  haproxy::backend { 'web':
#    ports          => '8140',
#    server_names   => $::hostname,
#    ipaddresses    => $::ipaddress,
#    server_options => 'check',
#    options        => 'log-health-checks',
#  }
#
define haproxy::backend (
  $ports,
  $name           = $title,
  $server_names   = $::hostname,
  $ipaddresses    = undef,
  $options        = '',
  $server_options = ''
) {
  # Template uses $name, $server_names, $ipaddresses, $ports, $options, server_options
  concat::fragment { "backend_${name}":
    order   => "30-backend-${name}",
    target  => '/etc/haproxy/haproxy.cfg',
    content => template('haproxy/haproxy_backend.erb'),
  }
}
