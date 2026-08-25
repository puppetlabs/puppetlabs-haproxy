# @summary
#   This type will set up a HTTP error group configuration block inside the haproxy.cfg
#   file on an haproxy load balancer.
#
# @note
#   See https://docs.haproxy.org/2.2/configuration.html#3.8 for more info
#
# @note
#   Currently requires the puppetlabs/concat module on the Puppet Forge
#
#
# @param section_name
#    This name goes right after the http-errors' statement in haproxy.cfg
#    Default: $name (the namevar of the resource).
#
# @param errorfile
#   Mapping of HTTP status codes to response files.
#   See https://docs.haproxy.org/2.2/configuration.html#3.8-errorfile
#   $errorfile = { 404 => '/usr/share/haproxy/errors/40x.html' }
#
# @param config_file
#   Optional. Path of the config file where this entry will be added.
#   Assumes that the parent directory exists.
#   Default: $haproxy::params::config_file
#
# @param instance
#   Optional. Defaults to 'haproxy'
#
define haproxy::http_errors (
  String[1]                           $section_name = $name,
  String                              $instance     = 'haproxy',
  Optional[Stdlib::Absolutepath]      $config_file  = undef,
  Hash[Integer, Stdlib::Absolutepath] $errorfile    = {},
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
    errorfile    => $errorfile,
  }

  concat::fragment { "${instance_name}-${section_name}_http_errors_block":
    order   => "16-${section_name}-00",
    target  => $_config_file,
    content => epp('haproxy/haproxy_http_errors_block.epp', $parameters),
  }
}
