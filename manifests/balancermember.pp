# == Define Resource Type: haproxy::balancermember
#
# This type will setup a balancer member inside a listening service
#  configuration block in /etc/haproxy/haproxy.cfg on the load balancer.
#  currently it only has the ability to specify the instance name,
#  ip address, port, and whether or not it is a backup. More features
#  can be added as needed. The best way to implement this is to export
#  this resource for all haproxy balancer member servers, and then collect
#  them on the main haproxy load balancer.
#
# === Requirement/Dependencies:
#
# Currently requires the puppetlabs/concat module on the Puppet Forge and
#  uses storeconfigs on the Puppet Master to export/collect resources
#  from all balancer members.
#
# === Parameters
#
# [*listening_service*]
#   The haproxy service's instance name (or, the title of the
#    haproxy::listen resource). This must match up with a declared
#    haproxy::listen resource.
#
# [*ports*]
#   An array or commas-separated list of ports for which the balancer member
#    will accept connections from the load balancer. Note that cookie values
#    aren't yet supported, but shouldn't be difficult to add to the
#    configuration. If you use an array in server_names and ipaddresses, the
#    same port is used for all balancermembers.
#
# [*server_names*]
#   The name of the balancer member server as known to haproxy in the
#    listening service's configuration block. This defaults to the
#    hostname. Can be an array of the same length as ipaddresses,
#    in which case a balancermember is created for each pair of
#    server_names and ipaddresses (in lockstep).
#
# [*ipaddresses*]
#   The ip address used to contact the balancer member server.
#    Can be an array, see documentation to server_names.
#
# [*options*]
#   An array of options to be specified after the server declaration
#    in the listening service's configuration block.
#
# [*define_cookies*]
#   If true, then add "cookie SERVERID" stickiness options.
#    Default false.
#
# [*defaults*]
#   Name of the defaults section the backend or listener use.
#   Defaults to undef.
#
# [*config_file*]
#   Optional. Path of the config file where this entry will be added.
#   Assumes that the parent directory exists.
#   Default: $haproxy::params::config_file
#
# [*verifyhost*]
#   Optional. Will add the verifyhost option to the server line, using the
#   specific host from server_names as an argument.
#   Default: false
#
# [*weight*]
#   Optional. Will add the weight option to the server line
#   Default: undef
#
# === Examples
#
#  Exporting the resource for a balancer member:
#
#  @@haproxy::balancermember { 'haproxy':
#    listening_service => 'puppet00',
#    ports             => '8140',
#    server_names      => $::hostname,
#    ipaddresses       => $::ipaddress,
#    options           => 'check',
#  }
#
#
#  Collecting the resource on a load balancer
#
#  Haproxy::Balancermember <<| listening_service == 'puppet00' |>>
#
#  Creating the resource for multiple balancer members at once
#  (for single-pass installation of haproxy without requiring a first
#  pass to export the resources if you know the members in advance):
#
#  haproxy::balancermember { 'haproxy':
#    listening_service => 'puppet00',
#    ports             => '8140',
#    server_names      => ['server01', 'server02'],
#    ipaddresses       => ['192.168.56.200', '192.168.56.201'],
#    options           => 'check',
#  }
#
#  (this resource can be declared anywhere)
#
define haproxy::balancermember (
  $listening_service,
  $type         = 'server',
  $ports        = undef,
  $server_names = $::hostname,
  $ipaddresses  = $::ipaddress,
  $prefix       = 'server',
  $amount       = '1',
  $fqdn_records = $::fqdn,
  $options      = '',
  $define_cookies = false,
  $instance     = 'haproxy',
  $defaults     = undef,
  Optional[Stdlib::Absolutepath] $config_file  = undef,
  $verifyhost   = false,
  $weight       = undef,
) {

  include ::haproxy::params

  if $instance == 'haproxy' {
    $instance_name = 'haproxy'
    $_config_file = pick($config_file, $haproxy::config_file)
  } else {
    $instance_name = "haproxy-${instance}"
    $_config_file = pick($config_file, inline_template($haproxy::params::config_file_tmpl))
  }

  if $defaults == undef {
    $order = "20-${listening_service}-01-${name}"
  } else {
    $order = "25-${defaults}-${listening_service}-02-${name}"
  }
  # Template uses $ipaddresses, $server_name, $ports, $option
  concat::fragment { "${instance_name}-${listening_service}_balancermember_${name}":
    order   => $order,
    target  => $_config_file,
    content => template('haproxy/haproxy_balancermember.erb'),
  }
}
