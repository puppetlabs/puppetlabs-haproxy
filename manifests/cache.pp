# @summary
#   Manage a HAProxy cache resource as documented in
#   https://www.haproxy.com/documentation/haproxy-configuration-manual/2-4r1/#6
#
# @param name
#   Name of the cache.
#
# @param total_max_size
#   Size of cache in megabytes. Maximum value is 4095.
#
# @param max_object_size
#   Maximum size of object to be cached. Must not be bigger than half of total_max_size.
#   If not set, it equals to 1/256th of total cache size.
#
# @param max_age
#   Maximum expiration time in seconds. The expiration is set as the lowest
#   value between the s-maxage or max-age (in this order) directive in the
#   Cache-Control response header and this value.
#
# @param instance
#   Optional. Defaults to 'haproxy'.
#
define haproxy::cache (
  Integer[1,4095] $total_max_size,
  Optional[Integer] $max_object_size = undef,
  Integer $max_age = 60,
  # Integer $max_secondary_entries
  String  $instance                 = 'haproxy',
) {
  include haproxy::params
  if $instance == 'haproxy' {
    $instance_name = 'haproxy'
    $config_file = $haproxy::config_file
  } else {
    $instance_name = "haproxy-${instance}"
    $config_file = inline_template($haproxy::params::config_file_tmpl)
  }

  $parameters = {
    'name'            => $name,
    'total_max_size'  => $total_max_size,
    'max_object_size' => $max_object_size,
    'max_age'         => $max_age,
  }

  # Templates uses $ipaddresses, $server_name, $ports, $option
  concat::fragment { "${instance_name}-cache-${name}":
    order   => "40-cache-${name}",
    target  => $config_file,
    content => epp('haproxy/haproxy_cache_block.epp', $parameters),
  }
}
