# @summary
#   This type will set up a userlist configuration block inside the haproxy.cfg
#   file on an haproxy load balancer.
#
# @note
#   See http://cbonte.github.io/haproxy-dconv/configuration-1.4.html#3.4 for more info
#
# @note
#   Currently requires the puppetlabs/concat module on the Puppet Forge
#
#
# @param section_name
#    This name goes right after the 'userlist' statement in haproxy.cfg
#    Default: $name (the namevar of the resource).
#
# @param users
#   An array of users in the userlist.
#   See http://cbonte.github.io/haproxy-dconv/configuration-1.4.html#3.4-user
#
# @param groups
#   An array of groups in the userlist.
#   See http://cbonte.github.io/haproxy-dconv/configuration-1.4.html#3.4-group
#
# @param config_file
#   Optional. Path of the config file where this entry will be added.
#   Assumes that the parent directory exists.
#   Default: $haproxy::params::config_file
#
# @param instance
#   Optional. Defaults to 'haproxy'
#
# === Authors
#
# Jeremy Kitchen <jeremy@nationbuilder.com>
#
define haproxy::userlist (
  Optional[Array[Variant[String, Sensitive[String]]]] $users        = undef,
  Optional[Array[String]]                             $groups       = undef,
  String                                              $instance     = 'haproxy',
  String[1]                                           $section_name = $name,
  Optional[Stdlib::Absolutepath]                      $config_file  = undef,
) {
  include haproxy::params

  $content = epp(
    'haproxy/haproxy_userlist_block.epp',
    {
      epp_users        => $users,
      epp_groups       => $groups,
      epp_section_name => $section_name,
    },
  )

  if $instance == 'haproxy' {
    $instance_name = 'haproxy'
    $_config_file = pick($config_file, $haproxy::config_file)
  } else {
    $instance_name = "haproxy-${instance}"
    $_config_file = pick($config_file, inline_template($haproxy::params::config_file_tmpl))
  }

  concat::fragment { "${instance_name}-${section_name}_userlist_block":
    order   => "12-${section_name}-00",
    target  => $_config_file,
    content => $content,
  }
}
