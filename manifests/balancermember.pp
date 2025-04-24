# @summary
#  This type will setup a balancer member inside a listening service
#  configuration block in /etc/haproxy/haproxy.cfg on the load balancer.
#  
# @note
#  Currently it only has the ability to specify the instance name,
#  ip address, port, and whether or not it is a backup. More features
#  can be added as needed. The best way to implement this is to export
#  this resource for all haproxy balancer member servers, and then collect
#  them on the main haproxy load balancer.
#
# @note
#  Currently requires the puppetlabs/concat module on the Puppet Forge and
#  uses storeconfigs on the Puppet Server to export/collect resources
#  from all balancer members.
#
#
# @param listening_service
#   The haproxy service's instance name (or, the title of the
#    haproxy::listen resource). This must match up with a declared
#    haproxy::listen resource.
#
# @param ports
#   An array or commas-separated list of ports for which the balancer member
#    will accept connections from the load balancer. Note that cookie values
#    aren't yet supported, but shouldn't be difficult to add to the
#    configuration. If you use an array in server_names and ipaddresses, the
#    same port is used for all balancermembers.
#
# @param port
#    A port for server-template. It is an optional specification.
#
# @param server_names
#   The name of the balancer member server as known to haproxy in the
#    listening service's configuration block. This defaults to the
#    hostname. Can be an array of the same length as ipaddresses,
#    in which case a balancermember is created for each pair of
#    server_names and ipaddresses (in lockstep).
#
# @param ipaddresses
#   The ip address used to contact the balancer member server.
#    Can be an array, see documentation to server_names.
#
# @param prefix
#   A prefix for the server-template for the server names to be built.
#
# @param amount
#   If "amount" is provided, the server-template initializes <num> servers
#    with 1 up to <num> as server name suffixes. A range of numbers
#    <num_low>-<num_high> may also be used to use <num_low> up to
#    <num_high> as server name suffixes.
#
# @param fqdn
#   A FQDN for all the servers the server-template initializes.
#
# @param options
#   An array of options to be specified after the server declaration
#    in the listening service's configuration block.
#
# @param define_cookies
#   If true, then add "cookie SERVERID" stickiness options.
#    Default false.
#
# @param defaults
#   Name of the defaults section the backend or listener use.
#   Defaults to undef.
#
# @param config_file
#   Optional. Path of the config file where this entry will be added.
#   Assumes that the parent directory exists.
#   Default: $haproxy::params::config_file
#
# @param verifyhost
#   Optional. Will add the verifyhost option to the server line, using the
#   specific host from server_names as an argument.
#   Default: false
#
# @param weight
#   Optional. Will add the weight option to the server line
#   Default: undef
#
# @param instance
#   Optional. Defaults to 'haproxy'
#
# @param type
#   Optional. Defaults to 'server'
#
# @example
#  Exporting the resource for a balancer member:
#
#  @@haproxy::balancermember { 'haproxy':
#    listening_service => 'puppet00',
#    ports             => [8140],
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
# @example
#  Creating the resource for multiple balancer members at once
#  (for single-pass installation of haproxy without requiring a first
#  pass to export the resources if you know the members in advance):
#
#  haproxy::balancermember { 'haproxy':
#    listening_service => 'puppet00',
#    ports             => 8140,
#    server_names      => ['server01', 'server02'],
#    ipaddresses       => ['192.168.56.200', '192.168.56.201'],
#    options           => 'check',
#  }
#
# @example
#  Implemented in HAPROXY 1.8:
#  Set a template to initialize servers with shared parameters.
#  The names of these servers are built from <prefix> and <amount> parameters.
#
#    Initializes 5 servers with srv1, srv2, srv3, srv4 and srv5 as names,
#    myserver.example.com as FQDN, 8140 as port, and health-check enabled.
#
#  haproxy::balancermember { 'haproxy':
#    listening_service => 'puppet00',
#    type              => 'server-template'
#    port              => '8140',
#    prefix            => 'srv',
#    amount            => '1-5',
#    fqdn              => 'myserver.example.com',
#    options           => 'check',
#  }
#
#  (this resource can be declared anywhere)
#
define haproxy::balancermember (
  String                                                $listening_service,
  Enum['server', 'default-server', 'server-template']   $type               = 'server',
  Optional[Variant[Array[Stdlib::Port,0],Stdlib::Port]] $ports              = undef,
  Optional[Variant[String, Stdlib::Port]]               $port               = undef,
  Variant[String[1], Array]                             $server_names       = $facts['networking']['hostname'],
  Variant[String, Array]                                $ipaddresses        = $facts['networking']['ip'],
  String                                                $prefix             = 'server',
  String                                                $amount             = '1',
  Optional[String]                                      $fqdn               = undef,
  Optional[Variant[String, Array]]                      $options            = undef,
  Boolean                                               $define_cookies     = false,
  String                                                $instance           = 'haproxy',
  Optional[String]                                      $defaults           = undef,
  Optional[Stdlib::Absolutepath]                        $config_file        = undef,
  Boolean                                               $verifyhost         = false,
  Optional[Variant[String, Integer]]                    $weight             = undef,
) {
  include haproxy::params

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

  $parameters = {
    'type'           => $type,
    'ipaddresses'    => $ipaddresses,
    'server_names'   => $server_names,
    'ports'          => $ports,
    'define_cookies' => $define_cookies,
    'options'        => $options,
    'verifyhost'     => $verifyhost,
    'weight'         => $weight,
    'prefix'         => $prefix,
    'amount'         => $amount,
    'fqdn'           => $fqdn,
    'port'           => $port,
  }
  # Template uses $ipaddresses, $server_name, $ports, $option
  concat::fragment { "${instance_name}-${listening_service}_balancermember_${name}":
    order   => $order,
    target  => $_config_file,
    content => epp('haproxy/haproxy_balancermember.epp', $parameters),
  }
}
