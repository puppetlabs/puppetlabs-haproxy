# @summary Program definition
#
# @param command
#   A command to be executed by haproxy master process
# @param user
#   User account used for executing command
# @param group
#   Assigned group
# @param options
#   By default, the process manager stops and recreates child programs at haproxy reload.
#   In order to disable this, set this parameter to `no option start-on-reload`
# @param instance
#   haproxy instance
# @param config_file
#   Path to haproxy config
# @see https://www.haproxy.com/documentation/haproxy-configuration-tutorials/programs/
# @example
#   haproxy::program { 'hello':
#     command => 'hello world',
#   }
define haproxy::program (
  String                          $command,
  Optional[String]                $user        = undef,
  Optional[String]                $group       = undef,
  Optional[String]                $options     = undef,
  String                          $instance    = 'haproxy',
  Optional[Stdlib::Absolutepath]  $config_file = undef,
) {
  # We derive these settings so that the caller only has to specify $instance.
  include haproxy::params

  if $instance == 'haproxy' {
    $instance_name = 'haproxy'
    $_config_file = pick($config_file, $haproxy::config_file)
  } else {
    $instance_name = "haproxy-${instance}"
    $_config_file = pick($config_file, inline_template($haproxy::params::config_file_tmpl))
  }

  concat::fragment { "${instance_name}-${name}_program":
    order   => "40-program-${name}",
    target  => $_config_file,
    content => epp('haproxy/haproxy_program.epp', {
        'name'    => $name,
        'command' => $command,
        'user'    => $user,
        'group'   => $group,
        'options' => $options,
    }),
  }
}
