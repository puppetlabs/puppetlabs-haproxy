#
define haproxy::peer (
  $peers_name,
  $port,
  $ensure       = 'present',
  $server_names = $::hostname,
  $ipaddresses  = $::ipaddress,
) {

  # We derive these settings so that the caller only has to specify $instance.
  include haproxy::params
  if $instance == 'haproxy' {
    $instance_name = 'haproxy'
    #$config_dir = $haproxy::params::config_dir
    $config_file = $haproxy::params::config_file
  } else {
    $instance_name = "haproxy-${instance}"
    #$config_dir = inline_template($haproxy::params::config_dir_tmpl)
    $config_file = inline_template($haproxy::params::config_file_tmpl)
  }

  # Templates uses $ipaddresses, $server_name, $ports, $option
  concat::fragment { "${instance_name}-peers-${peers_name}-${name}":
    order   => "30-peers-01-${peers_name}-${name}",
    ensure  => $ensure,
    target  => $config_file,
    content => template('haproxy/haproxy_peer.erb'),
  }
}
