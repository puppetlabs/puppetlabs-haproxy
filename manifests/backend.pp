# == Define Resource Type: haproxy::backend
#
# This type will setup a backend configuration block in /etc/haproxy/haproxy.cfg on the load balancer.
#
# === Requirement/Dependencies:
#
# Currently requires the ripienaar/concat module on the Puppet Forge and
#  uses storeconfigs on the Puppet Master to export/collect resources
#  from all balancer members.
#

define haproxy::backend (
  $listening_service,
  $mode         = undef,
  $ports,
  $server_names = $::hostname,
  $ipaddresses  = $::ipaddress,
  $check        = true,
  $options      = '',
  $acls         = '',
  $define_cookies = false,
) {
  concat::fragment { "${listening_service}_acls_${name}":
    order   => "20-${listening_service}-${name}",
    target  => '/etc/haproxy/haproxy.cfg',
    content => template('haproxy/haproxy_acls.erb'),
  }
  concat::fragment { "${listening_service}_backend_block_${name}":
    order   => "30-${listening_service}-${name}",
    target  => '/etc/haproxy/haproxy.cfg',
    content => template('haproxy/haproxy_backend.erb'),
  }
}
