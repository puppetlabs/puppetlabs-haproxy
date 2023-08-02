# @summary
#   This type will setup a ring configuration block inside
#   the haproxy.cfg file.
#
# @note
#   Currently requires the puppetlabs/concat module on the Puppet Forge and
#   uses storeconfigs on the Puppet Server to export/collect resources
#   from all balancer members.
#
# @param section_name
#    This name goes right after the 'ring' statement in haproxy.cfg
#    Default: $name (the namevar of the resource).
#
# @param description
#   Optional. Allows to add a sentence to describe the related object in the HAProxy HTML
#   stats page. The description will be printed on the right of the object name
#   it describes. Usefull in huge environments
#
# @param format
#   Format used to store events into the ring buffer.
#
# @param maxlen
#   The maximum length of an event message stored into the ring,
#   including formatted header. If an event message is longer than
#   <length>, it will be truncated to this length.
#
# @param size
#   Optional. This is the size in bytes for the ring-buffer.
#
# @param backing_file
#    Optional. This replaces the regular memory allocation by a RAM-mapped 
#    file to store the ring. 
#
# @param timeout_connect
#    Optional. Set the maximum time to wait for a connection attempt to a server to succeed.
#
# @param timeout_server
#   Optional. Set the maximum time for pending data staying into output buffer.
#
# @param servers
#    Array of server parameter. Used to configure a tcp server to forward messages
#    from ring buffer. This supports for all "server" parameters.
#
# @param instance
#   Optional. Defaults to 'haproxy' 
#
# @example
#  haproxy::ring { 'ring00':
#    description     => 'my haproxy ring',
#    format          => 'rfc5424',
#    maxlen          => 4096,
#    size            => 32764,
#    timeout_connect => 5,
#    timeout_server  => 10,
#    servers         => [
#      'main 192.168.0.1:1514 check',
#      'backup 192.168.0.2:1514 check backup'
#    ],
#  }
#
# === Authors
#
# Alexis Courteille <alexis.courteille@gmail.com>
#
define haproxy::ring (
  Optional[String]  $description              = undef,
  String            $format                   = undef,
  Integer           $maxlen                   = undef,
  Integer           $size                     = undef,
  Optional[String]  $backing_file             = undef,
  Optional[Integer] $timeout_connect          = undef,
  Optional[Integer] $timeout_server           = undef,
  Array             $servers                  = undef,
  String            $instance                 = 'haproxy',
  String[1]         $section_name             = $name,
) {
  include haproxy::params

  if $instance == 'haproxy' {
    $instance_name = 'haproxy'
    $_config_file = pick($config_file, $haproxy::config_file)
  } else {
    $instance_name = "haproxy-${instance}"
    $_config_file = pick($config_file, inline_template($haproxy::params::config_file_tmpl))
  }

  include haproxy::globals

  $order = "20-${section_name}-00"
  $parameters = {
    'section_name'             => $section_name,
    'description'              => $description,
    'format'                   => $format,
    'maxlen'                   => $maxlen,
    'size'                     => $size,
    'backing_file'             => $backing_file,
    'timeout_connect'          => $timeout_connect,
    'timeout_server'           => $timeout_server,
    'servers'                  => $servers,
  }

  # Template uses: $section_name, $ipaddress, $ports, $options
  concat::fragment { "${instance_name}-${section_name}_ring_block":
    order   => $order,
    target  => $_config_file,
    content => epp('haproxy/haproxy_ring_block.epp', $parameters),
  }
}
