# == Define Resource Type: haproxy::userlist
#
# This type will set up a userlist configuration block inside the haproxy.cfg
#  file on an haproxy load balancer.
#
# See http://cbonte.github.io/haproxy-dconv/configuration-1.4.html#3.4 for more info
#
# === Requirement/Dependencies:
#
# Currently requires the puppetlabs/concat module on the Puppet Forge
#
# === Parameters
#
# [*section_name*]
#    This name goes right after the 'userlist' statement in haproxy.cfg
#    Default: $name (the namevar of the resource).
#
# [*users*]
#   An array of users in the userlist.
#   See http://cbonte.github.io/haproxy-dconv/configuration-1.4.html#3.4-user
#
# [*groups*]
#   An array of groups in the userlist.
#   See http://cbonte.github.io/haproxy-dconv/configuration-1.4.html#3.4-group
#
# === Authors
#
# Jeremy Kitchen <jeremy@nationbuilder.com>
#
define haproxy::userlist (
  $users = undef,
  $groups = undef,
  $instance = 'haproxy',
  $section_name = $name,
) {
  include haproxy::params
  if $instance == 'haproxy' {
    $instance_name = 'haproxy'
    $config_file = $haproxy::params::config_file
  } else {
    $instance_name = "haproxy-${instance}"
    $config_file = inline_template($haproxy::params::config_file_tmpl)
  }

  # Template uses $section_name, $users, $groups
  concat::fragment { "${instance_name}-${section_name}_userlist_block":
    order   => "12-${section_name}-00",
    target  => $config_file,
    content => template('haproxy/haproxy_userlist_block.erb'),
  }
}
