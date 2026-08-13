# @summary
#   This type will set up a ring-buffer configuration block inside the haproxy.cfg
#   file on an haproxy load balancer.
#
# @note
#   See https://docs.haproxy.org/2.2/configuration.html#3.9 for more info
#
# @note
#   Currently requires the puppetlabs/concat module on the Puppet Forge
#
#
# @param section_name
#    This name goes right after the 'ring' statement in haproxy.cfg
#    Default: $name (the namevar of the resource).
#
# @param description
#   Descriptive message for the CLI.
#   See https://docs.haproxy.org/2.2/configuration.html#3.9-description
#
# @param format
#   Format used to store events into the ring buffer.
#   See https://docs.haproxy.org/2.2/configuration.html#3.9-format
#
# @param maxlen
#   The maximum length of an event message stored into the ring.
#   See https://docs.haproxy.org/2.2/configuration.html#3.9-maxlen
#
# @param size
#   Ring buffer size.
#   See https://docs.haproxy.org/2.2/configuration.html#3.9-size
#
# @param timeout
#   Hash of timeout for various phases of the write operation
#   $timeout = { 'connect' => '10s', 'server' => '5s' }
#
# @param server
#   Mapping of Syslog TCP server names to address (and optional parameters).
#   See https://docs.haproxy.org/2.2/configuration.html#3.9-server
#   $server = { 'mysyslogsrv' => '127.0.0.1:6514 log-proto octet-count' }
#
# @param config_file
#   Optional. Path of the config file where this entry will be added.
#   Assumes that the parent directory exists.
#   Default: $haproxy::params::config_file
#
# @param instance
#   Optional. Defaults to 'haproxy'
#
define haproxy::ring (
  String[1]                             $section_name = $name,
  String                                $instance     = 'haproxy',
  Optional[Stdlib::Absolutepath]        $config_file  = undef,
  Optional[String[1]]                   $description  = undef,
  Optional[Haproxy::Ring_buffer_format] $format       = undef,
  Optional[Integer[1]]                  $maxlen       = undef,
  Optional[Integer[1]]                  $size         = undef,
  Hash                                  $timeout      = {},
  Hash                                  $server       = {},
) {
  include haproxy::params

  if $instance == 'haproxy' {
    $instance_name = 'haproxy'
    $_config_file  = pick($config_file, $haproxy::config_file)
  } else {
    $instance_name = "haproxy-${instance}"
    $_config_file  = pick($config_file, inline_template($haproxy::params::config_file_tmpl))
  }

  assert_type(Stdlib::AbsolutePath, dirname($_config_file))

  $parameters = {
    section_name => $section_name,
    description  => $description,
    format       => $format,
    maxlen       => $maxlen,
    size         => $size,
    timeout      => $timeout,
    server       => $server,
  }

  concat::fragment { "${instance_name}-${section_name}_ring_block":
    order   => "17-${section_name}-00",
    target  => $_config_file,
    content => epp('haproxy/haproxy_ring_block.epp', $parameters),
  }
}
