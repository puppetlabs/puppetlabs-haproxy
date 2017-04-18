# == Define Resource Type: haproxy::balancermember
#
# This type will setup a balancer member inside a listening service
# It expects that the haproxy file written will be written as a consul
# template (so not directly written into /etc/haproxy.cfg)/, typically
# to the file /etc/consul-template/haproxy.ctmpl. consul-template
# will convert this template into the real /etc/haproxy/haproxy.cfg file.
#
# === Requirement/Dependencies:
#
# Currently requires the puppetlabs/concat module on the Puppet Forge.
# It has been tested with the gdhbashton/consul_template file as follows:
#
#  class { 'consul_template':
#    init_style     => 'upstart',
#  }
#
#  class { '::haproxy':
#    global_options   => $haproxy_globals,
#    defaults_options => $haproxy_defaults,
#    config_file      => "${consul_template::config_dir}/haproxy.ctmpl",
#  }
#
#  Service['consul-template'] -> Service['haproxy']
#
#  consul_template::watch { 'haproxy':
#    destination   => '/etc/haproxy/haproxy.cfg',
#    command       => '/etc/init.d/haproxy reload',
#  }
#
# === Parameters
#
# [*name*]
#   The name of the service to query consul for. The resulting
#   service records will be used to populate the server entries.
#
# [*ensure*]
#   If the balancermember should be present or absent.
#    Defaults to present.
#
# [*listening_service*]
#   The haproxy service's instance name (or, the title of the
#    haproxy::listen resource). This must match up with a declared
#    haproxy::listen resource.
#
# [*options*]
#   An array of options to be specified after the server declaration
#    in the listening service's configuration block.
#
# [*define_cookies*]
#   If true, then add "cookie SERVERID" stickiness options.
#    Default false.
#
#  haproxy::balancermember_consul { 'keystone':
#    listening_service => 'keystone',
#    options           => 'check',
#  }
#
#  (this resource can be declared anywhere)
#
define haproxy::balancermember_consul(
  $listening_service,
  $ensure       = 'present',
  $options      = '',
  $define_cookies = false
) {

  # Template uses $ipaddresses, $server_name, $ports, $option
  concat::fragment { "${listening_service}_balancermember_consul_${name}":
    ensure  => $ensure,
    order   => "20-${listening_service}-01-${name}",
    target  => $::haproxy::config_file,
    content => template('haproxy/haproxy_balancermember_consul.erb'),
  }
}
