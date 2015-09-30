#haproxy

####Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with haproxy](#setup)
    * [Beginning with haproxy](#beginning-with-haproxy)
4. [Usage - Configuration options and additional functionality](#usage)
    * [Configure HAProxy options](#configure-haproxy-options)
    * [Configure HAProxy daemon listener](#configure-haproxy-daemon-listener)
    * [Configure multi-network daemon listener](#configure-multi-network-daemon-listener)
    * [Configure HAProxy load-balanced member nodes](#configure-haproxy-load-balanced-member-nodes)
    * [Configure a load balancer with exported resources](#configure-a-load-balancer-with-exported-resources)
    * [Set up a frontend service](#set-up-a-frontend-service)
    * [Set up a backend service](#set-up-a-backend-service)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
6. [Limitations - OS compatibility, etc.](#limitations)
7. [Development - Guide for contributing to the module](#development)

##Overview

The haproxy module lets you use Puppet to install, configure, and manage HAProxy.

##Module Description

HAProxy is a daemon for load-balancing and proxying TCP- and HTTP-based services. This module lets you use Puppet to configure HAProxy servers and backend member servers.

##Setup

###Beginning with haproxy

The quickest way to get up and running using the haproxy module is to install and configure a basic HAProxy server that is listening on port 8140 and balanced against two nodes:

~~~puppet
node 'haproxy-server' {
  class { 'haproxy': }
  haproxy::listen { 'puppet00':
    collect_exported => false,
    ipaddress        => $::ipaddress,
    ports            => '8140',
  }
  haproxy::balancermember { 'master00':
    listening_service => 'puppet00',
    server_names      => 'master00.example.com',
    ipaddresses       => '10.0.0.10',
    ports             => '8140',
    options           => 'check',
  }
  haproxy::balancermember { 'master01':
    listening_service => 'puppet00',
    server_names      => 'master01.example.com',
    ipaddresses       => '10.0.0.11',
    ports             => '8140',
    options           => 'check',
  }
}
~~~

##Usage

###Configure HAProxy options

The main [`haproxy` class](#class-haproxy) has many options for configuring your HAProxy server:

~~~puppet
class { 'haproxy':
  global_options   => {
    'log'     => "${::ipaddress} local0",
    'chroot'  => '/var/lib/haproxy',
    'pidfile' => '/var/run/haproxy.pid',
    'maxconn' => '4000',
    'user'    => 'haproxy',
    'group'   => 'haproxy',
    'daemon'  => '',
    'stats'   => 'socket /var/lib/haproxy/stats',
  },
  defaults_options => {
    'log'     => 'global',
    'stats'   => 'enable',
    'option'  => [
      'redispatch',
    ],
    'retries' => '3',
    'timeout' => [
      'http-request 10s',
      'queue 1m',
      'connect 10s',
      'client 1m',
      'server 1m',
      'check 10s',
    ],
    'maxconn' => '8000',
  },
}
~~~

The above shown values are the module's defaults for platforms like Debian and RedHat (see `haproxy::params` for details). If you wish to override any of these defaults set `global_options` and/or `defaults_options` to a hash containing just the `option => value` pairs you need changed. Note that array values that are present in both the default hash and your supplied hash are concatenated and duplicate items removed:

~~~puppet
class { 'haproxy':
  global_options   => {
    'user'    => 'root',
    'group'   => 'root',
    'stats'   => [
      'socket /var/lib/haproxy/stats',
      'timeout 30s'
    ]
  },
  defaults_options => {
    'retries' => '5',
    'timeout' => [
      'http-request 7s',
      'connect 3s',
      'check 9s',
    ],
    'maxconn' => '15000',
  },
}
~~~

###Configure HAProxy daemon listener

To export the resource for a balancermember and collect it on a single HAProxy load balancer server:

~~~puppet
haproxy::listen { 'puppet00':
  ipaddress => $::ipaddress,
  ports     => '18140',
  mode      => 'tcp',
  options   => {
    'option'  => [
      'tcplog',
      'ssl-hello-chk',
    ],
    'balance' => 'roundrobin',
  },
}
~~~

###Configure multi-network daemon listener

If you need a more complex configuration for the listen block, use the `$bind` parameter:

~~~puppet
haproxy::listen { 'puppet00':
  mode    => 'tcp',
  options => {
    'option'  => [
      'tcplog',
      'ssl-hello-chk',
    ],
    'balance' => 'roundrobin',
  },
  bind    => {
    '10.0.0.1:443'             => ['ssl', 'crt', 'puppetlabs.com'],
    '168.12.12.12:80'          => [],
    '192.168.122.42:8000-8100' => ['ssl', 'crt', 'puppetlabs.com'],
    ':8443,:8444'              => ['ssl', 'crt', 'internal.puppetlabs.com']
  },
}
~~~

**Note:** `$ports` and `$ipaddress` cannot be used in combination with `$bind`.

###Configure HAProxy load-balanced member nodes

First export the resource for a balancermember:

~~~puppet
@@haproxy::balancermember { 'haproxy':
  listening_service => 'puppet00',
  ports             => '8140',
  server_names      => $::hostname,
  ipaddresses       => $::ipaddress,
  options           => 'check',
}
~~~

Then collect the resource on a load balancer:

~~~puppet
Haproxy::Balancermember <<| listening_service == 'puppet00' |>>
~~~

Then create the resource for multiple balancermembers at once:

~~~puppet
haproxy::balancermember { 'haproxy':
  listening_service => 'puppet00',
  ports             => '8140',
  server_names      => ['server01', 'server02'],
  ipaddresses       => ['192.168.56.200', '192.168.56.201'],
  options           => 'check',
}
~~~

This example assumes a single-pass installation of HAProxy where you know the members in advance. Otherwise, you'd need a first pass to export the resources.

###Configure a load balancer with exported resources

Install and configure an HAProxy service listening on port 8140 and balanced against all collected nodes:

~~~puppet
node 'haproxy-server' {
  class { 'haproxy': }
  haproxy::listen { 'puppet00':
    ipaddress => $::ipaddress,
    ports     => '8140',
  }
}

node /^master\d+/ {
  @@haproxy::balancermember { $::fqdn:
    listening_service => 'puppet00',
    server_names      => $::hostname,
    ipaddresses       => $::ipaddress,
    ports             => '8140',
    options           => 'check',
  }
}
~~~

The resulting HAProxy service uses storeconfigs to collect and realize balancermember servers, and automatically collects configurations from backend servers. The backend nodes export their HAProxy configurations to the Puppet master, which then distributes them to the HAProxy server.

###Set up a frontend service

This example routes traffic from port 8140 to all balancermembers added to a backend with the title 'puppet_backend00':

~~~puppet
haproxy::frontend { 'puppet00':
  ipaddress     => $::ipaddress,
  ports         => '18140',
  mode          => 'tcp',
  bind_options  => 'accept-proxy',
  options       => {
    'default_backend' => 'puppet_backend00',
    'timeout client'  => '30s',
    'option'          => [
      'tcplog',
      'accept-invalid-http-request',
    ],
  },
}
~~~

If option order is important, pass an array of hashes to the `options` parameter:

~~~puppet
haproxy::frontend { 'puppet00':
  ipaddress     => $::ipaddress,
  ports         => '18140',
  mode          => 'tcp',
  bind_options  => 'accept-proxy',
  options       => [
    { 'default_backend' => 'puppet_backend00' },
    { 'timeout client'  => '30s' },
    { 'option'          => [
        'tcplog',
        'accept-invalid-http-request',
      ],
    }
  ],
}
~~~

This adds the frontend options to the configuration block in the same order as they appear within your array.

###Set up a backend service

~~~puppet
haproxy::backend { 'puppet00':
  options => {
    'option'  => [
      'tcplog',
      'ssl-hello-chk',
    ],
    'balance' => 'roundrobin',
  },
}
~~~

If option order is important, pass an array of hashes to the `options` parameter:

~~~puppet
haproxy::backend { 'puppet00':
  options => [
    { 'option'  => [
        'tcplog',
        'ssl-hello-chk',
      ]
    },
    { 'balance' => 'roundrobin' },
    { 'cookie'  => 'C00 insert' },
  ],
}
~~~

This adds the backend options to the configuration block in the same order as they appear within the array.

##Reference

###Classes

####Public classes

* [`haproxy`](#class-haproxy): Main configuration class.

####Private classes

* `haproxy::params`: Sets parameter defaults per operating system.
* `haproxy::install`: Installs packages.
* `haproxy::config`: Configures haproxy.cfg.
* `haproxy::service`: Manages the haproxy service.

###Defines

####Public defines

* [`haproxy::listen`](#define-haproxylisten): Creates a listen entry in haproxy.cfg.
* [`haproxy::frontend`](#define-haproxyfrontend): Creates a frontend entry in haproxy.cfg.
* [`haproxy::backend`](#define-haproxybackend): Creates a backend entry in haproxy.cfg.
* [`haproxy::balancermember`](#define-haproxybalancermember): Creates server entries for listen or backend blocks in haproxy.cfg.
* [`haproxy::userlist`](#define-haproxyuserlist): Creates a userlist entry in haproxy.cfg.
* [`haproxy::peers`](#define-haproxypeers): Creates a peers entry in haproxy.cfg.
* [`haproxy::peer`](#define-haproxypeer): Creates server entries within a peers entry in haproxy.cfg.

####Private defines

* `haproxy::balancermember::collect_exported`: Collects exported balancermembers.
* `haproxy::peer::collect_exported`: Collects exported peers.

#### Class: `haproxy`

Main class, includes all other classes.

##### Parameters (all optional)

* `custom_fragment`: Inserts an arbitrary string into the configuration file. Useful for configurations not available through other parameters. Valid options: a string (e.g., output from the template() function). Default: undef.

* `defaults_options`: Configures all the default HAProxy options at once. Valid options: a hash of `option => value` pairs. To set an option multiple times (e.g. multiple 'timeout' or 'stats' values) pass its value as an array. Each element in your array results in a separate instance of the option, on a separate line in haproxy.cfg. Default:

  ~~~puppet
  {
          'log'     => 'global',
          'stats'   => 'enable',
          'option'  => [
            'redispatch',
          ],
          'retries' => '3',
          'timeout' => [
            'http-request 10s',
            'queue 1m',
            'connect 10s',
            'client 1m',
            'server 1m',
            'check 10s',
          ],
          'maxconn' => '8000'
  }
  ~~~

  To override any of these default values you don't have to recreate and supply the whole hash, just set `defaults_options` to a hash of the `option => value` pairs you'd like to override. Note that array values that are present in both the default hash and your supplied hash are concatenated and duplicate items removed. Example:

  ~~~puppet
  {
          'retries' => '5',
          'timeout' => [
            'http-request 7s',
            'connect 5s',
          ],
          'maxconn' => '12000'
  }
  ~~~

* `global_options`: Configures all the global HAProxy options at once. Valid options: a hash of `option => value` pairs. To set an option multiple times (e.g. multiple 'timeout' or 'stats' values) pass its value as an array. Each element in your array results in a separate instance of the option, on a separate line in haproxy.cfg. Default:

  ~~~puppet
  {
          'log'     => "${::ipaddress} local0",
          'chroot'  => '/var/lib/haproxy',
          'pidfile' => '/var/run/haproxy.pid',
          'maxconn' => '4000',
          'user'    => 'haproxy',
          'group'   => 'haproxy',
          'daemon'  => '',
          'stats'   => 'socket /var/lib/haproxy/stats'
  }
  ~~~

  To override any of these default values you don't have to recreate and supply the whole hash, just set `global_options` to a hash of the `option => value` pairs you'd like to override. Note that array values that are present in both the default hash and your supplied hash are concatenated and duplicate items removed. Example:

  ~~~puppet
  {
          'user'  => 'root',
          'group' => 'root',
          'stats' => [
            'socket /var/lib/haproxy/admin.sock mode 660 level admin',
            'timeout 30s',
          ]
  }
  ~~~

* `package_ensure`: Specifies whether the HAProxy package should exist. Defaults to 'present'. Valid options: 'present' and 'absent'. Default: 'present'.

* `package_name`: Specifies the name of the HAProxy package. Valid options: a string. Default: 'haproxy'.

* `restart_command`: Specifies a command that Puppet can use to restart the service after configuration changes. Passed directly as the `restart` parameter to Puppet's native [`service` resource](https://docs.puppetlabs.com/references/latest/type.html#service). Valid options: a string. Default: undef (if not specified, Puppet uses the `service` default).

* `service_ensure`: Specifies whether the HAProxy service should be enabled at boot and running, or disabled at boot and stopped. Valid options: 'running' and 'stopped'. Default: 'running'.

* `service_manage`: Specifies whether the state of the HAProxy service should be managed by Puppet. Valid options: 'true' and 'false'. Default: 'true'.

* `service_options`: Contents for the `/etc/defaults/haproxy` file on Debian. Defaults to "ENABLED=1\n" on Debian, and is ignored on other systems.

#### Define: `haproxy::balancermember`

Configures a service inside a listening or backend service configuration block in haproxy.cfg.

##### Parameters

* `define_cookies`: *Optional.* Specifies whether to add 'cookie SERVERID' stickiness options. Valid options: 'true' and 'false'. Default: 'false'.

* `ensure`: Specifies whether the balancermember should be listed in haproxy.cfg. Valid options: 'present' and 'absent'. Default: 'present'.

* `ipaddresses`: *Optional.* Specifies the IP address used to contact the balancermember service. Valid options: a string or an array. If you pass an array, it must contain the same number of elements as the array you pass to the `server_names` parameter. For each pair of entries in the `ipaddresses` and `server_names` arrays, Puppet creates server entries in haproxy.cfg targeting each port specified in the `ports` parameter. Default: the value of the `$::ipaddress` fact.

* `listening_service`: *Required.* Associates the balancermember with an `haproxy::listen` resource. Valid options: a string matching the title of a declared `haproxy::listen` resource.

* `options`: *Optional.* Adds one or more options to the listening service's configuration block in haproxy.cfg, following the server declaration. Valid options: a string or an array. Default: ''.

* `ports`: *Optional.* Specifies one or more ports on which the load balancer sends connections to balancermembers. Valid options: an array. Default: undef. If no port is specified, the load balancer forwards traffic on the same port as received on the frontend.

* `server_names`: *Required unless `collect_exported` is set to `true`.* Sets the name of the balancermember service in the listening service's configuration block in haproxy.cfg. Valid options: a string or an array. If you pass an array, it must contain the same number of elements as the array you pass to the `ipaddresses` parameter. For each pair of entries in the `ipaddresses` and `server_names` arrays, Puppet creates server entries in haproxy.cfg targeting each port specified in the `ports` parameter. Default: the value of the `$::hostname` fact.

#### Define: `haproxy::backend`

Sets up a backend service configuration block inside haproxy.cfg. Each backend service needs one or more balancermember services (declared with the [`haproxy::balancermember` define](#define-haproxybalancermember)).

##### Parameters

* `collect_exported`: *Optional.* Specifies whether to collect resources exported by other nodes. This serves as a form of autodiscovery. Valid options: 'true' and 'false'. If set to 'false', Puppet only manages balancermembers that you specify through the `haproxy::balancermembers` define. Default: 'true'.

* `name`: *Optional.* Supplies a name for the backend service. This value appears right after the 'backend' statement in haproxy.cfg. Valid options: a string. Default: the title of your declared resource.

* `options`: *Optional.* Adds one or more options to the backend service's configuration block in haproxy.cfg. Valid options: a hash or an array. To control the ordering of these options within the configuration block, supply an array of hashes where each hash contains one 'option => value' pair. Default:

~~~puppet
{
    'option'  => [
      'tcplog',
      'ssl-hello-chk'
    ],
    'balance' => 'roundrobin'
}
~~~

#### Define: `haproxy::frontend`

Sets up a frontend service configuration block inside haproxy.cfg. Each frontend service needs one or more balancermember services (declared with the [`haproxy::balancermember` define](#define-haproxybalancermember)).

##### Parameters

* `bind`: *Required unless `ports` and `ipaddress` are specified.* Adds one or more bind lines to the frontend service's configuration block in haproxy.cfg. Valid options: a hash of `'address:port' => [parameters]` pairs, where the key is a comma-delimited list of one or more listening addresses and ports passed as a string, and the value is an array of bind options. For example:

~~~puppet
bind => {
  '168.12.12.12:80'                     => [],
  '192.168.1.10:8080,192.168.1.10:8081' => [],
  '10.0.0.1:443-453'                    => ['ssl', 'crt', 'puppetlabs.com'],
  ':8443,:8444'                         => ['ssl', 'crt', 'internal.puppetlabs.com'],
  '/var/run/haproxy-frontend.sock'      => [ 'user root', 'mode 600', 'accept-proxy' ],
}
~~~

For more information, see the [HAProxy Configuration Manual](http://cbonte.github.io/haproxy-dconv/configuration-1.5.html#4.2-bind).

* `bind_options`: Deprecated. This setting has never functioned in any version of the haproxy module. Use `bind` instead.

* `ipaddress`: *Required unless `bind` is specified.* Specifies an IP address for the proxy to bind to. Valid options: a string. If left unassigned or set to '*' or '0.0.0.0', the proxy listens to all valid addresses on the system.

* `mode`: *Optional.* Sets the mode of operation for the frontend service. Valid options: 'tcp', 'http', and 'health'. Default: undef.

* `name`: *Optional.* Supplies a name for the frontend service. This value appears right after the 'frontend' statement in haproxy.cfg. Valid options: a string. Default: the title of your declared resource.

* `options`: *Optional.* Adds one or more options to the frontend service's configuration block in haproxy.cfg. Valid options: a hash or an array. To control the ordering of these options within the configuration block, supply an array of hashes where each hash contains one 'option => value' pair. Default:

~~~puppet
{
    'option'  => [
      'tcplog',
    ],
}
~~~

* `ports`: *Required unless `bind` is specified.* Specifies which ports to listen on for the address specified in `ipaddress`. Valid options: an array of port numbers and/or port ranges or a string containing a comma-delimited list of port numbers/ranges.

#### Define: `haproxy::listen`

Sets up a listening service configuration block inside haproxy.cfg. Each listening service configuration needs one or more balancermember services (declared with the [`haproxy::balancermember` define](#define-haproxybalancermember)).

##### Parameters

* `bind`: *Required unless `ports` and `ipaddress` are specified.* Adds one or more bind options to the listening service's configuration block in haproxy.cfg. Valid options: a hash of `'address:port' => [parameters]` pairs, where the key is a comma-delimited list of one or more listening addresses and ports passed as a string, and the value is an array of bind options. For example:

~~~puppet
bind => {
  '168.12.12.12:80'                     => [],
  '192.168.1.10:8080,192.168.1.10:8081' => [],
  '10.0.0.1:443-453'                    => ['ssl', 'crt', 'puppetlabs.com'],
  ':8443,:8444'                         => ['ssl', 'crt', 'internal.puppetlabs.com'],
  '/var/run/haproxy-frontend.sock'      => [ 'user root', 'mode 600', 'accept-proxy' ],
}
~~~

For more information, see the [HAProxy Configuration Manual](http://cbonte.github.io/haproxy-dconv/configuration-1.5.html#4.2-bind).

* `bind_options`: Deprecated. This setting has never functioned in any version of the haproxy module. Use `bind` instead.

* `collect_exported`: *Optional.* Specifies whether to collect resources exported by other nodes. This serves as a form of autodiscovery. Valid options: 'true' and 'false'. If set to 'false', Puppet only manages balancermembers that you specify through the `haproxy::balancermembers` define. Default: 'true'.

* `ipaddress`: *Required unless `bind` is specified.* Specifies an IP address for the proxy to bind to. Valid options: a string. If left unassigned or set to '*' or '0.0.0.0', the proxy listens to all valid addresses on the system.

* `mode`: *Optional.* Sets the mode of operation for the listening service. Valid options: 'tcp', 'http', and 'health'. Default: undef.

* `name`: *Optional.* Supplies a name for the listening service. This value appears right after the 'listen' statement in haproxy.cfg. Valid options: a string. Default: the title of your declared resource.

* `options`: *Optional.* Adds one or more options to the listening service's configuration block in haproxy.cfg. Valid options: a hash or an array. To control the ordering of these options within the configuration block, supply an array of hashes where each hash contains one 'option => value' pair.

* `ports`: *Required unless `bind` is specified.* Specifies which ports to listen on for the address specified in `ipaddress`. Valid options: a single comma-delimited string or an array of strings. Each string can contain a port number or a hyphenated range of port numbers (e.g., 8443-8450).

#### Define: `haproxy::userlist`

Sets up a [userlist configuration block](http://cbonte.github.io/haproxy-dconv/configuration-1.4.html#3.4) inside haproxy.cfg.

##### Parameters

* `groups`: *Required unless `users` is specified.* Adds groups to the userlist. For more information, see the [HAProxy Configuration Manual](http://cbonte.github.io/haproxy-dconv/configuration-1.4.html#3.4-group). Valid options: an array of groupnames. Default: undef.

* `name`: *Optional.* Supplies a name for the userlist. This value appears right after the 'listen' statement in haproxy.cfg. Valid options: a string. Default: the title of your declared resource.

* `users`: *Required unless `groups` is specified.* Adds users to the userlist. For more information, see the [HAProxy Configuration Manual](http://cbonte.github.io/haproxy-dconv/configuration-1.4.html#3.4-user). Valid options: an array of usernames. Default: undef.

#### Define: `haproxy::peers`

Sets up a peers entry in haproxy.cfg on the load balancer. This entry is required to share the current state of HAProxy with other HAProxy instances in high-availability configurations.

##### Parameters

* `collect_exported`: *Optional.* Specifies whether to collect resources exported by other nodes. This serves as a form of autodiscovery. Valid options: 'true' and 'false'. Default: 'true'.

* `name`: *Optional.* Appends a name to the peers entry in haproxy.cfg. Valid options: a string. Default: the title of your declared resource.

#### Define: `haproxy::peer`

Sets up a peer entry inside the peers configuration block in haproxy.cfg.

##### Parameters

* `ensure`: Specifies whether the peer should exist in the configuration block. Valid options: 'present' or 'absent'. Default: 'present'.

* `ipaddresses`: *Required unless the `collect_exported` parameter of your `haproxy::peers` resource is set to `true`.* Specifies the IP address used to contact the peer member server. Valid options: a string or an array. If you pass an array, it must contain the same number of elements as the array you pass to the `server_names` parameter. Puppet pairs up the elements from both arrays and creates a peer for each pair of values. Default: the value of the `$::ipaddress` fact.

* `peers_name`: *Required.* Specifies the peer in which to add the load balancer. Valid options: a string containing the name of an HAProxy peer.

* `ports`: *Required.* Specifies the port on which the load balancer sends connections to peers. Valid options: a string containing a port number.

* `server_names`: *Required unless the `collect_exported` parameter of your `haproxy::peers` resource is set to `true`.* Sets the name of the peer server as listed in the peers configuration block. Valid options: a string or an array. If you pass an array, it must contain the same number of elements as the array you pass to `ipaddresses`. Puppet pairs up the elements from both arrays and creates a peer for each pair of values. Default: the value of the `$::hostname` fact.

##Limitations

This module is tested and officially supported on the following platforms:

* RHEL versions 5, 6, and 7
* Ubuntu versions 10.04, 12.04, and 14.04
* Debian versions 6 and 7
* Scientific Linux versions 5, 6, and 7
* CentOS versions 5, 6, and 7
* Oracle Linux versions 5, 6, and 7

Testing on other platforms has been light and cannot be guaranteed.

## Development
Puppet Labs modules on the Puppet Forge are open projects, and community contributions are essential for keeping them great. We can't access the huge number of platforms and myriad hardware, software, and deployment configurations that Puppet is intended to serve. We want to keep it as easy as possible to contribute changes so that our modules work in your environment. There are a few guidelines that we need contributors to follow so that we can have a chance of keeping on top of things.

For more information, see our [module contribution guide.](https://docs.puppetlabs.com/forge/contributing.html)

To see who's already involved, see the [list of contributors.](https://github.com/puppetlabs/puppetlabs-haproxy/graphs/contributors)
