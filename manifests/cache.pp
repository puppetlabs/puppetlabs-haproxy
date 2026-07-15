# @summary
#   Manage a HAProxy cache resource as documented in
#   https://www.haproxy.com/documentation/haproxy-configuration-manual/latest/#6
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
# @param process_vary
#   Available since HAProxy 2.4. Turn on or off the processing of the Vary header
#   in a response. For more info, check https://www.haproxy.com/documentation/haproxy-configuration-manual/latest/#6.2.1-process-vary
#
# @param max_secondary_entries
#   Available since HAProxy 2.4. Define the maximum number of simultaneous secondary
#   entries with the same primary key in the cache. This needs the vary support to
#   be enabled. Its default value is 10 and should be passed a strictly positive integer.
#
# @param instance
#   Optional. Defaults to 'haproxy'.
#
define haproxy::cache (
  Integer[1,4095] $total_max_size,
  Optional[Integer] $max_object_size = undef,
  Integer $max_age = 60,
  Optional[Enum['on', 'off']] $process_vary = undef,
  Optional[Integer[1]] $max_secondary_entries = undef,
  String  $instance = 'haproxy',
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
    'name'                  => $name,
    'total_max_size'        => $total_max_size,
    'max_object_size'       => $max_object_size,
    'max_age'               => $max_age,
    'process_vary'          => $process_vary,
    'max_secondary_entries' => $max_secondary_entries,
  }

  # Templates uses $ipaddresses, $server_name, $ports, $option
  concat::fragment { "${instance_name}-cache-${name}":
    order   => "30-cache-${name}",
    target  => $config_file,
    content => epp('haproxy/haproxy_cache.epp', $parameters),
  }
}
