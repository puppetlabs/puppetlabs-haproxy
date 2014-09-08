# == Define Resource Type: haproxy::frontend::acl
#
# This type will setup an acl inside the frontend service configuration
# block inside  the haproxy.cfg file on an haproxy load balancer.
#
# === Requirement/Dependencies:
#
# Currently requires the puppetlabs/concat module on the Puppet Forge and
#  uses storeconfigs on the Puppet Master to export/collect resources
#  from all balancer members.
#
# === Parameters
# [*frontend_name*]
#   name of haproxy::frontend resource to rely
#
# [*acl_name*]
#   acl name. If not specified <name> will be used
#
# [*condition*]
#   condition that must be satisfied to match acl
#
# [*use_backend*]
#   backend to use if acl if matched
#
# === Examples
#
#  Exporting the resource for a balancer member:
#
#  haproxy::frontend { 'puppet00':
#    ipaddress    => '*',
#    ports        => '18140',
#    mode         => 'tcp',
#    bind_options => 'accept-proxy',
#    options      => {
#      'option'   => [
#        'tcplog',
#        'accept-invalid-http-request',
#      ],
#      'timeout client' => '30',
#      'balance'    => 'roundrobin'
#    },
#  }
#
#  haproxy::frontend::acl { 'puppet00-acl':
#    frontend_name => 'puppet00',
#    condition     => 'dst 127.0.0.1',
#    acl_name      => 'acl_1',
#    use_backend   => ''
#  }

define haproxy::frontend::acl (
  $frontend_name,
  $condition,
  $acl_name       = $title,
  $use_backend    = ''
) {

  if !defined(Haproxy::Frontend[$frontend_name]) {
    fail ("No Haproxy::Frontend[$frontend_name] is defined!")
  }

  # Template uses: $name, $ipaddress, $ports, $options
  concat::fragment { "${frontend_name}_frontend_acl_${acl_name}_block":
    order   => "15-${frontend_name}-01-${acl_name}",
    target  => '/etc/haproxy/haproxy.cfg',
    content => template('haproxy/haproxy_frontend_acl.erb'),
  }

  if ($use_backend!='') {
    if !defined(Haproxy::Backend[$use_backend]) {
      fail ("No Haproxy::Backend[$use_backend] is defined!")
    }

    haproxy::frontend::use_backend { "${use_backend}-${acl_name}":
      frontend_name => $frontend_name,
      backend_name  => $use_backend,
      if_acl        => $acl_name,
    }
  }
}
