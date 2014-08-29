# == Define Resource Type: haproxy::frontend::use_backend
#
# This type will setup an use_backend if an acl is mathed inside the
# frontend service configuration block inside the haproxy.cfg file
# on an haproxy load balancer.
#
# === Requirement/Dependencies:
#
# Currently requires the puppetlabs/concat module on the Puppet Forge and
#  uses storeconfigs on the Puppet Master to export/collect resources
#  from all balancer members.
#
# == Parameters
# 
# [*frontend_name*]
#   name of haproxy::frontend to rely
# 
# [*backend_name*]
#   backend to use id specified acl is matched
# 
# [*if_acl*]
#   acl name that nedd to be matched
# 

define haproxy::frontend::use_backend (
  $frontend_name,
  $backend_name,
  $if_acl
) {

  if !defined(Haproxy::Frontend[$frontend_name]) {
    fail ("No Haproxy::Frontend[$frontend_name] is defined!")
  }

  # Template uses: $name, $ipaddress, $ports, $options
  concat::fragment { "${$frontend_name}_frontend_use_${backend_name}_block":
    order   => "15-${frontend_name}-02-${backend_name}",
    target  => '/etc/haproxy/haproxy.cfg',
    content => template('haproxy/haproxy_frontend_use_backend.erb'),
  }
}
