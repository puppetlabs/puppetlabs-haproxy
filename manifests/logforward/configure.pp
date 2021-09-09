# @summary
#   Hiera support to setup a Log forwarding service configuration block inside
#   the haproxy.cfg file on an haproxy load balancer.
#
# @param logforward
#   Hash [param*]
#
# @example
#  Exporting the resource for a balancer member:
#
# === Authors
#
# Erwin Dwight S. Paler <erwin.dwight.paler@gmail.com>
#
class haproxy::logforward::configure (
  Hash $instance = {},
) {

  include ::haproxy

  $instance.each |$name, $params| {
    $ipaddress = $params['address'] ? {
      Stdlib::IP::Address => $params['address'],
      undef       => undef,
      default     => find_ip($params['address']),
    }
    haproxy::logforward {
      $name:
        * => $params,
        ;
      default:
        ipaddress => $ipaddress,
        ;
    }

  }
}
