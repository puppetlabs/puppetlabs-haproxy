# == Define Resource Type: haproxy::mailer
#
# This type will set up a mailer entry inside the mailers configuration block in
# haproxy.cfg on the load balancer. Currently, it has the ability to
# specify the instance name, ip address, ports and server_names.
#
# Automatic discovery of mailer nodes may be implemented by exporting the mailer
# resource for all HAProxy balancer servers that are configured in the same HA
# block and then collecting them on all load balancers.
#
# === Parameters:
#
# [*mailers_name*]
#  Specifies the mailer in which this load balancer needs to be added.
#
# [*server_names*]
#  Sets the name of the mailer server in the mailers configuration block.
#   Defaults to the hostname. Can be an array. If this parameter is
#   specified as an array, it must be the same length as the
#   ipaddresses parameter's array. A mailer is created for each pair
#   of server\_names and ipaddresses in the array.
#
# [*ipaddresses*]
#  Specifies the IP address used to contact the mailer member server.
#   Can be an array. If this parameter is specified as an array it
#   must be the same length as the server\_names parameter's array.
#   A mailer is created for each pair of address and server_name.
#
# [*ports*]
#  Sets the port on which the mailer is going to share the state.
#
# [*config_file*]
#   Optional. Path of the config file where this entry will be added.
#   Assumes that the parent directory exists.
#   Default: $haproxy::params::config_file

define haproxy::mailer (
  $mailers_name,
  $port,
  $server_names = $::hostname,
  $ipaddresses  = $::ipaddress,
  $instance     = 'haproxy',
) {
  include ::haproxy::params
  if $instance == 'haproxy' {
    $instance_name = 'haproxy'
    $config_file = $::haproxy::config_file
  } else {
    $instance_name = "haproxy-${instance}"
    $config_file = inline_template($haproxy::params::config_file_tmpl)
  }

  # Templates uses $ipaddresses, $server_name, $ports, $option
  concat::fragment { "${instance_name}-mailers-${mailers_name}-${name}":
    order   => "40-mailers-01-${mailers_name}-${name}",
    target  => $config_file,
    content => template('haproxy/haproxy_mailer.erb'),
  }
}
