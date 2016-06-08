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
    * [Configure multiple haproxy instances on one machine](#configure-multiple-haproxy-instances-on-one-machine)
    * [Manage a map file](#manage-a-map-file)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
6. [Limitations - OS compatibility, etc.](#limitations)
7. [Development - Guide for contributing to the module](#development)

##Overview

The haproxy module lets you use Puppet to install, configure, and manage HAProxy.

##Module Description

HAProxy is a daemon for load-balancing and proxying TCP- and HTTP-based services. This module lets you use Puppet to configure HAProxy servers and backend member servers.

##Setup

###Beginning with haproxy

The simplest HAProxy configuration consists of a server that listens on a port and balances against some other nodes:

~~~puppet
node 'haproxy-server' {
  include ::haproxy
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

The above shown values are the module's defaults for platforms like Debian and RedHat (see `haproxy::params` for details). If you wish to override or add to any of these defaults set `merge_options => true` (see below) and set `global_options` and/or `defaults_options` to a hash containing just the `option => value` pairs you need changed or added. In case of duplicates your supplied values will "win" over the default values (this is especially noteworthy for arrays -- they cannot be merged easily). If you want to completely remove a parameter set it to the special value `undef`:

~~~puppet
class { 'haproxy':
  global_options   => {
    'maxconn' => undef,
    'user'    => 'root',
    'group'   => 'root',
    'stats'   => [
      'socket /var/lib/haproxy/stats',
      'timeout 30s'
    ]
  },
  defaults_options => {
    'retries' => '5',
    'option'  => [
      'redispatch',
      'http-server-close',
      'logasap',
    ],
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
  include ::haproxy
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
      ]
    },
    { 'balance' => 'roundrobin' },
    { 'cookie'  => 'C00 insert' },
  ],
}
~~~

###Set up stick-tables for a frontend (or a backend)

~~~puppet
haproxy::backend { 'backend01':
  options => [
    { 'stick-table' => 'type ip size 1 nopurge peers LB' },
    { 'stick'       => 'on dst' },
  ],
}
~~~

This adds the backend options to the configuration block in the same order as they appear within the array.

###Configure multiple haproxy instances on one machine

This is an advanced feature typically only used at large sites.

It is possible to run multiple haproxy processes ("instances") on the
same machine. This has the benefit that each is a distinct failure domain,
each can be restarted independently, and each can run a different binary.

In this use case, instead of using `Class['haproxy']`, each process
is started using `haproxy::instance{'inst'}` where `inst` is the
name of the instance.  It assumes there is a matching `Service['inst']`
that will be used to manage service.  Different sites may have
different requirements for how the `Service[]` is constructed.
However, `haproxy::instance_service` exists as an example of one
way to do this, and may be sufficient for most sites.

In this example, two instances are created. The first uses the standard
class and uses `haproxy::instance` to add an additional instance called
`beta`.

~~~puppet
   include ::haproxy
   haproxy::listen { 'puppet00':
     instance         => 'haproxy',
     collect_exported => false,
     ipaddress        => $::ipaddress,
     ports            => '8800',
   }

   haproxy::instance { 'beta': }
   ->
   haproxy::instance_service { 'beta':
     haproxy_package     => 'custom_haproxy',
     haproxy_init_source => "puppet:///modules/${module_name}/haproxy-beta.init",
   }
   ->
   haproxy::listen { 'puppet00':
     instance         => 'beta',
     collect_exported => false,
     ipaddress        => $::ipaddress,
     ports            => '9900',
   }
~~~

In this example, two instances are created called `group1` and `group2`.
The second uses a custom package.

~~~puppet
   haproxy::instance { 'group1': }
   ->
   haproxy::instance_service { 'group1':
     haproxy_init_source => "puppet:///modules/${module_name}/haproxy-group1.init",
   }
   ->
   haproxy::listen { 'group1-puppet00':
     section_name     => 'puppet00',
     instance         => 'group1',
     collect_exported => false,
     ipaddress        => $::ipaddress,
     ports            => '8800',
   }
   haproxy::instance { 'group2': }
   ->
   haproxy::instance_service { 'group2':
     haproxy_package     => 'custom_haproxy',
     haproxy_init_source => "puppet:///modules/${module_name}/haproxy-group2.init",
   }
   ->
   haproxy::listen { 'group2-puppet00':
     section_name     => 'puppet00',
     instance         => 'group2',
     collect_exported => false,
     ipaddress        => $::ipaddress,
     ports            => '9900',
   }
~~~

### Manage a map file

~~~puppet
haproxy::mapfile { 'domains-to-backends':
  ensure   => 'present',
  mappings => [
    { 'app01.example.com' => 'bk_app01' },
    { 'app02.example.com' => 'bk_app02' },
    { 'app03.example.com' => 'bk_app03' },
    { 'app04.example.com' => 'bk_app04' },
    'app05.example.com bk_app05',
    'app06.example.com bk_app06',
  ],
}
~~~

This creates a file `/etc/haproxy/domains-to-backends.map` containing the mappings specified in the `mappings` array.

The map file can then be used in a frontend to map `Host:` values to backends, implementing name-based virtual hosting:

```
frontend ft_allapps
  [...]
  use_backend %[req.hdr(host),lower,map(/etc/haproxy/domains-to-backends.map,bk_default)]
```

Or expressed using `haproxy::frontend`:

~~~puppet
haproxy::frontend { 'ft_allapps':
  ipaddress => '0.0.0.0',
  ports     => '80',
  mode      => 'http',
  options   => {
    'use_backend' => '%[req.hdr(host),lower,map(/etc/haproxy/domains-to-backends.map,bk_default)]'
  }
}
~~~

##Reference

###Classes

####Public classes

* [`haproxy`](#class-haproxy): Main configuration class.
* [`haproxy::globals`](#class-haproxy-globals): Global configuration options.

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
* [`haproxy::mailers`](#define-haproxymailers): Creates a mailers entry in haproxy.cfg.
* [`haproxy::mailer`](#define-haproxymailer): Creates server entries within a mailers entry in haproxy.cfg.
* [`haproxy::instance`](#define-instance): Creates multiple instances of haproxy on the same machine.
* [`haproxy::instance_service`](#define-instanceservice): Example of one way to prepare environment for haproxy::instance.
* [`haproxy::mapfile`](#define-haproxymapfile): Manages an HAProxy [map file](https://cbonte.github.io/haproxy-dconv/configuration-1.5.html#7.3.1-map).
* [`haproxy::defaults`](#define-defaults): Option to use multipe defaults sections.

####Private defines

* `haproxy::balancermember::collect_exported`: Collects exported balancermembers.
* `haproxy::peer::collect_exported`: Collects exported peers.
* `haproxy::mailer::collect_exported`: Collects exported mailers.

#### Class: `haproxy`

Main class, includes all other classes.

##### Parameters (all optional)

* `custom_fragment`: Inserts an arbitrary string into the configuration file. Useful for configurations not available through other parameters. Valid options: a string (e.g., output from the template() function). Default: undef.

* `defaults_options`: Configures all the default HAProxy options at once. Valid options: a hash of `option => value` pairs. To set an option multiple times (e.g. multiple 'timeout' or 'stats' values) pass its value as an array. Each element in your array results in a separate instance of the option, on a separate line in haproxy.cfg. Default:

  ```puppet
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
  ```

  To override or add to any of these default values you don't have to recreate and supply the whole hash, just set `merge_options => true` (see below) and set `defaults_options` to a hash of the `option => value` pairs you'd like to override or add. But note that array values cannot be easily merged with the default values without potentially creating duplicates so you always have to supply the whole array yourself. And if you want a parameter to not appear at all in the resulting configuration set its value to `undef`. Example:

  ```puppet
  {
    'retries' => '5',
    'timeout' => [
      'http-request 7s',
      'http-keep-alive 10s,
      'queue 1m',
      'connect 5s',
      'client 1m',
      'server 1m',
      'check 10s',
    ],
    'maxconn' => undef,
  }
  ```

* `global_options`: Configures all the global HAProxy options at once. Valid options: a hash of `option => value` pairs. To set an option multiple times (e.g. multiple 'timeout' or 'stats' values) pass its value as an array. Each element in your array results in a separate instance of the option, on a separate line in haproxy.cfg. Default:

  ```puppet
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
  ```

  To override or add to any of these default values you don't have to recreate and supply the whole hash, just set `merge_options => true` (see below) and set `global_options` to a hash of the `option => value` pairs you'd like to override or add. But note that array values cannot be easily merged with the default values without potentially creating duplicates so you always have to supply the whole array yourself. And if you want a parameter to not appear at all in the resulting configuration set its value to `undef`. Example:

  ```puppet
  {
    'log'   => undef,
    'user'  => 'root',
    'group' => 'root',
    'stats' => [
      'socket /var/lib/haproxy/admin.sock mode 660 level admin',
      'timeout 30s',
    ],
  }
  ```

* `merge_options`: Whether to merge the user-supplied `global_options`/`defaults_options` hashes with their default values set in params.pp. Merging allows to change or add options without having to recreate the entire hash. Defaults to `false`, but will default to `true` in future releases.

* `package_ensure`: Specifies whether the HAProxy package should exist. Defaults to 'present'. Valid options: 'present' and 'absent'. Default: 'present'.

* `package_name`: Specifies the name of the HAProxy package. Valid options: a string. Default: 'haproxy'.

* `restart_command`: Specifies a command that Puppet can use to restart the service after configuration changes. Passed directly as the `restart` parameter to Puppet's native [`service` resource](https://docs.puppetlabs.com/references/latest/type.html#service). Valid options: a string. Default: undef (if not specified, Puppet uses the `service` default).

* `service_ensure`: Specifies whether the HAProxy service should be enabled at boot and running, or disabled at boot and stopped. Valid options: 'running' and 'stopped'. Default: 'running'.

* `service_manage`: Specifies whether the state of the HAProxy service should be managed by Puppet. Valid options: 'true' and 'false'. Default: 'true'.

* `service_options`: Contents for the `/etc/defaults/haproxy` file on Debian. Defaults to "ENABLED=1\n" on Debian, and is ignored on other systems.

* `sysconfig_options`: Contents for the `/etc/sysconfig/haproxy` file on RedHat(-based) systems. Defaults to OPTIONS="" on RedHat(-based) systems and is ignored on others

* `config_dir`: Path to the directory in which the main configuration file `haproxy.cfg` resides. Will also be used for storing any managed map files (see [`haproxy::mapfile`](#define-haproxymapfile). Default depends on platform.

#### Class: `haproxy::globals`

For global configuration options used by all haproxy instances.

##### Parameters (all optional)

* `sort_options_alphabetic`: Sort options either alphabetic or custom like haproxy internal sorts them. Defaults to true.

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

* `instance`: *Optional.* When using `haproxy::instance` to run multiple instances of Haproxy on the same machine, this indicates which instance.  Defaults to "haproxy".

* `defaults`: *Optional.* Name of the defaults section the backend or listener use. Defaults to undef.

#### Define: `haproxy::backend`

Sets up a backend service configuration block inside haproxy.cfg. Each backend service needs one or more balancermember services (declared with the [`haproxy::balancermember` define](#define-haproxybalancermember)).

##### Parameters

* `collect_exported`: *Optional.* Specifies whether to collect resources exported by other nodes. This serves as a form of autodiscovery. Valid options: 'true' and 'false'. If set to 'false', Puppet only manages balancermembers that you specify through the `haproxy::balancermembers` define. Default: 'true'.

* `name`: *Optional.* Supplies a name for the backend service. This value appears right after the 'backend' statement in haproxy.cfg. Valid options: a string. Default: the title of your declared resource.

* `options`: *Optional.* Adds one or more options to the backend service's configuration block in haproxy.cfg. Valid options: a hash or an array. To control the ordering of these options within the configuration block, supply an array of hashes where each hash contains one 'option => value' pair. Default:

  ```puppet
  {
    'option'  => [
      'tcplog',
      'ssl-hello-chk'
    ],
    'balance' => 'roundrobin'
  }
  ```

* `instance`: *Optional.* When using `haproxy::instance` to run multiple instances of Haproxy on the same machine, this indicates which instance.  Defaults to "haproxy".

* `sort_options_alphabetic`: Sort options either alphabetic or custom like haproxy internal sorts them. Defaults to `haproxy::globals::sort_options_alphabetic`.

* `defaults`: *Optional* Name of the defaults section this backend will use. Defaults to undef which means the global defaults section will be used.

#### Define: `haproxy::frontend`

Sets up a frontend service configuration block inside haproxy.cfg. Each frontend service needs one or more balancermember services (declared with the [`haproxy::balancermember` define](#define-haproxybalancermember)).

##### Parameters

* `bind`: *Required unless `ports` and `ipaddress` are specified.* Adds one or more bind lines to the frontend service's configuration block in haproxy.cfg. Valid options: a hash of `'address:port' => [parameters]` pairs, where the key is a comma-delimited list of one or more listening addresses and ports passed as a string, and the value is an array of bind options. For example:

  ```puppet
  bind => {
    '168.12.12.12:80'                     => [],
    '192.168.1.10:8080,192.168.1.10:8081' => [],
    '10.0.0.1:443-453'                    => ['ssl', 'crt', 'puppetlabs.com'],
    ':8443,:8444'                         => ['ssl', 'crt', 'internal.puppetlabs.com'],
    '/var/run/haproxy-frontend.sock'      => [ 'user root', 'mode 600', 'accept-proxy' ],
  }
  ```

For more information, see the [HAProxy Configuration Manual](http://cbonte.github.io/haproxy-dconv/configuration-1.5.html#4.2-bind).

* `bind_options`: Deprecated. This setting has never functioned in any version of the haproxy module. Use `bind` instead.

* `ipaddress`: *Required unless `bind` is specified.* Specifies an IP address for the proxy to bind to. Valid options: a string. If left unassigned or set to '*' or '0.0.0.0', the proxy listens to all valid addresses on the system.

* `mode`: *Optional.* Sets the mode of operation for the frontend service. Valid options: 'tcp', 'http', and 'health'. Default: undef.

* `name`: *Optional.* Supplies a name for the frontend service. This value appears right after the 'frontend' statement in haproxy.cfg. Valid options: a string. Default: the title of your declared resource.

* `options`: *Optional.* Adds one or more options to the frontend service's configuration block in haproxy.cfg. Valid options: a hash or an array. To control the ordering of these options within the configuration block, supply an array of hashes where each hash contains one 'option => value' pair.

  ```puppet
  {
    'option'  => [
      'tcplog',
    ],
  }
  ```

* `ports`: *Required unless `bind` is specified.* Specifies which ports to listen on for the address specified in `ipaddress`. Valid options: an array of port numbers and/or port ranges or a string containing a comma-delimited list of port numbers/ranges.

* `instance`: *Optional.* When using `haproxy::instance` to run multiple instances of Haproxy on the same machine, this indicates which instance.  Defaults to "haproxy".

* `sort_options_alphabetic`: Sort options either alphabetic or custom like haproxy internal sorts them. Defaults to `haproxy::globals::sort_options_alphabetic`.

* `defaults`: *Optional* Name of the defaults section this frontend will use. Defaults to undef which means the global defaults section will be used.

* `defaults_use_backend`: If defaults are used and a default backend is configured use the backend name for ordering. This means that the frontend is placed in the configuration file before the backend configuration. Defaults to true.

#### Define: `haproxy::listen`

Sets up a listening service configuration block inside haproxy.cfg. Each listening service configuration needs one or more balancermember services (declared with the [`haproxy::balancermember` define](#define-haproxybalancermember)).

##### Parameters

* `bind`: *Required unless `ports` and `ipaddress` are specified.* Adds one or more bind options to the listening service's configuration block in haproxy.cfg. Valid options: a hash of `'address:port' => [parameters]` pairs, where the key is a comma-delimited list of one or more listening addresses and ports passed as a string, and the value is an array of bind options. For example:

  ```puppet
  bind => {
    '168.12.12.12:80'                     => [],
    '192.168.1.10:8080,192.168.1.10:8081' => [],
    '10.0.0.1:443-453'                    => ['ssl', 'crt', 'puppetlabs.com'],
    ':8443,:8444'                         => ['ssl', 'crt', 'internal.puppetlabs.com'],
    '/var/run/haproxy-frontend.sock'      => [ 'user root', 'mode 600', 'accept-proxy' ],
  }
  ```

For more information, see the [HAProxy Configuration Manual](http://cbonte.github.io/haproxy-dconv/configuration-1.5.html#4.2-bind).

* `bind_options`: Deprecated. This setting has never functioned in any version of the haproxy module. Use `bind` instead.

* `collect_exported`: *Optional.* Specifies whether to collect resources exported by other nodes. This serves as a form of autodiscovery. Valid options: 'true' and 'false'. If set to 'false', Puppet only manages balancermembers that you specify through the `haproxy::balancermembers` define. Default: 'true'.

* `ipaddress`: *Required unless `bind` is specified.* Specifies an IP address for the proxy to bind to. Valid options: a string. If left unassigned or set to '*' or '0.0.0.0', the proxy listens to all valid addresses on the system.

* `mode`: *Optional.* Sets the mode of operation for the listening service. Valid options: 'tcp', 'http', and 'health'. Default: undef.

* `name`: *Optional.* Supplies a name for the listening service. This value appears right after the 'listen' statement in haproxy.cfg. Valid options: a string. Default: the title of your declared resource.

* `options`: *Optional.* Adds one or more options to the listening service's configuration block in haproxy.cfg. Valid options: a hash or an array. To control the ordering of these options within the configuration block, supply an array of hashes where each hash contains one 'option => value' pair.

* `ports`: *Required unless `bind` is specified.* Specifies which ports to listen on for the address specified in `ipaddress`. Valid options: a single comma-delimited string or an array of strings. Each string can contain a port number or a hyphenated range of port numbers (e.g., 8443-8450).

* `sort_options_alphabetic`: Sort options either alphabetic or custom like haproxy internal sorts them. Defaults to `haproxy::globals::sort_options_alphabetic`.

* `defaults`: *Optional* Name of the defaults section this listen section will use. Defaults to undef which means the global defaults section will be used.

#### Define: `haproxy::userlist`

Sets up a [userlist configuration block](http://cbonte.github.io/haproxy-dconv/configuration-1.4.html#3.4) inside haproxy.cfg.

##### Parameters

* `groups`: *Required unless `users` is specified.* Adds groups to the userlist. For more information, see the [HAProxy Configuration Manual](http://cbonte.github.io/haproxy-dconv/configuration-1.4.html#3.4-group). Valid options: an array of groupnames. Default: undef.

* `name`: *Optional.* Supplies a name for the userlist. This value appears right after the 'userlist' statement in haproxy.cfg. Valid options: a string. Default: the title of your declared resource.

* `users`: *Required unless `groups` is specified.* Adds users to the userlist. For more information, see the [HAProxy Configuration Manual](http://cbonte.github.io/haproxy-dconv/configuration-1.4.html#3.4-user). Valid options: an array of usernames. Default: undef.

* `instance`: *Optional.* When using `haproxy::instance` to run multiple instances of Haproxy on the same machine, this indicates which instance.  Defaults to "haproxy".

#### Define: `haproxy::peers`

Sets up a peers entry in haproxy.cfg on the load balancer. This entry is required to share the current state of HAProxy with other HAProxy instances in high-availability configurations.

##### Parameters

* `collect_exported`: *Optional.* Specifies whether to collect resources exported by other nodes. This serves as a form of autodiscovery. Valid options: 'true' and 'false'. Default: 'true'.

* `name`: *Optional.* Appends a name to the peers entry in haproxy.cfg. Valid options: a string. Default: the title of your declared resource.

* `instance`: *Optional.* When using `haproxy::instance` to run multiple instances of Haproxy on the same machine, this indicates which instance.  Defaults to "haproxy".

#### Define: `haproxy::peer`

Sets up a peer entry inside the peers configuration block in haproxy.cfg.

##### Parameters

* `ipaddresses`: *Required unless the `collect_exported` parameter of your `haproxy::peers` resource is set to `true`.* Specifies the IP address used to contact the peer member server. Valid options: a string or an array. If you pass an array, it must contain the same number of elements as the array you pass to the `server_names` parameter. Puppet pairs up the elements from both arrays and creates a peer for each pair of values. Default: the value of the `$::ipaddress` fact.

* `peers_name`: *Required.* Specifies the peer in which to add the load balancer. Valid options: a string containing the name of an HAProxy peer.

* `port`: *Required.* Specifies the port on which the load balancer sends connections to peers. Valid options: a string containing a port number.

* `server_names`: *Required unless the `collect_exported` parameter of your `haproxy::peers` resource is set to `true`.* Sets the name of the peer server as listed in the peers configuration block. Valid options: a string or an array. If you pass an array, it must contain the same number of elements as the array you pass to `ipaddresses`. Puppet pairs up the elements from both arrays and creates a peer for each pair of values. Default: the value of the `$::hostname` fact.

* `instance`: *Optional.* When using `haproxy::instance` to run multiple instances of Haproxy on the same machine, this indicates which instance.  Defaults to "haproxy".

#### Define: `haproxy::mailers`

Sets up a mailers entry in haproxy.cfg on the load balancer to send email to each mailer that is configured in a mailers section alerts when the state of servers changes.

##### Parameters

* `collect_exported`: *Optional.* Specifies whether to collect resources exported by other nodes. This serves as a form of autodiscovery. Valid options: 'true' and 'false'. Default: 'true'.

* `name`: *Optional.* Appends a name to the mailers entry in haproxy.cfg. Valid options: a string. Default: the title of your declared resource.

* `instance`: *Optional.* When using `haproxy::instance` to run multiple instances of Haproxy on the same machine, this indicates which instance.  Defaults to "haproxy".

#### Define: `haproxy::mailer`

Sets up a mailer entry inside the mailers configuration block in haproxy.cfg.

##### Parameters
* `ipaddresses`: *Required unless the `collect_exported` parameter of your `haproxy::mailers` resource is set to `true`.* Specifies the IP address used to contact the mailer email server. Valid options: a string or an array. If you pass an array, it must contain the same number of elements as the array you pass to the `server_names` parameter. Puppet pairs up the elements from both arrays and creates a mailer for each pair of values. Default: the value of the `$::ipaddress` fact.

* `mailers_name`: *Required.* Specifies the name of a valid `haproxy::mailers` resource. Valid options: a string containing the name of an HAProxy mailer.

* `port`: *Required.* Specifies the port to which the load balancer makes its smtp connection. Valid options: a string containing a port number.

* `server_names`: *Required unless the `collect_exported` parameter of your `haproxy::mailers` resource is set to `true`.* Sets the name of the email server as listed in the mailers configuration block. Valid options: a string or an array. If you pass an array, it must contain the same number of elements as the array you pass to `ipaddresses`. Puppet pairs up the elements from both arrays and creates a mailer for each pair of values. Default: the value of the `$::hostname` fact.

* `instance`: *Optional.* When using `haproxy::instance` to run multiple instances of Haproxy on the same machine, this indicates which instance.  Defaults to "haproxy".

#### Define: `haproxy::instance`

Runs multiple instances of haproxy on the same machine.  Normally users
use the Class['haproxy'], which runs a single haproxy daemon on a machine.

##### Parameters

* `package_ensure`: Chooses whether the haproxy package should be installed or uninstalled.
Defaults to 'present'

* `package_name`:
The package name of haproxy. Defaults to undef, and no package is installed.
NOTE: Class['haproxy'] has a different default.

* `service_ensure`:
Chooses whether the haproxy service should be running & enabled at boot, or
stopped and disabled at boot. Defaults to 'running'

* `service_manage`:
Chooses whether the haproxy service state should be managed by puppet at
all. Defaults to true

* `global_options`:
A hash of all the haproxy global options. If you want to specify more
than one option (i.e. multiple timeout or stats options), pass those
options as an array and you will get a line for each of them in the
resultant haproxy.cfg file.

* `defaults_options`:
A hash of all the haproxy defaults options. If you want to specify more
than one option (i.e. multiple timeout or stats options), pass those
options as an array and you will get a line for each of them in the
resultant haproxy.cfg file.

* `restart_command`:
Command to use when restarting the on config changes.
Passed directly as the <code>'restart'</code> parameter to the service
resource.
Defaults to undef i.e. whatever the service default is.

* `custom_fragment`:
Allows arbitrary HAProxy configuration to be passed through to support
additional configuration not available via parameters, or to short-circuit
the defined resources such as haproxy::listen when an operater would rather
just write plain configuration. Accepts a string (ie, output from the
template() function). Defaults to undef

* `config_file`:
Allows arbitrary config filename to be specified. If this is used,
it is assumed that the directory path to the file exists and has
owner/group/permissions as desired.  If set to undef, the name
will be generated as follows:
If $title is 'haproxy', the operating system default will be used.
Otherwise, /etc/haproxy-$title/haproxy-$title.conf (Linux),
or /usr/local/etc/haproxy-$title/haproxy-$title.conf (FreeBSD)
The parent directory will be created automatically.
Defaults to undef.

#### Define: `haproxy::instance_service`

Example manifest that shows one way to create the Service[] environment needed
by haproxy::instance.

##### Parameters

* `haproxy_package`:
The name of the package to be installed. This is useful if
you package your own custom version of haproxy.
Defaults to 'haproxy'

* `bindir`:
Where to put symlinks to the binary used for each instance.
Defaults to '/opt/haproxy/bin'

* `haproxy_init_source`:
Path to the template init.d script that will start/restart/reload this instance.

* `haproxy_unit_template`:
Path to the template systemd service unit definition that will start/restart/reload this instance.

#### Define: `haproxy::mapfile`

Manages an HAProxy [map file](https://cbonte.github.io/haproxy-dconv/configuration-1.5.html#7.3.1-map). A map allows to map data in input to other data on output. This is especially useful for efficiently mapping domain names to backends, thus effectively implementing name-based virtual hosting. A map file contains one key + value per line. These key-value pairs are specified in the `mappings` array.

This article on the HAProxy blog gives a nice overview of the use case: http://blog.haproxy.com/2015/01/26/web-application-name-to-backend-mapping-in-haproxy/

##### Parameters

* `namevar`: The namevar of the defined resource type is the filename of the map file (without any extension), relative to the `haproxy::config_dir` directory. A '.map' extension is added automatically.

* `mappings`: An array of mappings for this map file. Array elements may be Hashes with a single key-value pair each (preferably) or simple Strings. Default: `[]`. Example:

  ```puppet
  mappings => [
    { 'app01.example.com' => 'bk_app01' },
    { 'app02.example.com' => 'bk_app02' },
    { 'app03.example.com' => 'bk_app03' },
    { 'app04.example.com' => 'bk_app04' },
    'app05.example.com bk_app05',
    'app06.example.com bk_app06',
  ]
  ```

* `ensure`: The state of the underlying file resource, either 'present' or 'absent'. Default: 'present'

* `owner`: The owner of the underlying file resource. Defaut: 'root'

* `group`: The group of the underlying file resource. Defaut: 'root'

* `mode`:  The mode of the underlying file resource. Defaut: '0644'

* `instances`: Array of names of managed HAproxy instances to notify (restart/reload) when the map file is updated. This is so that the same map file can be used with multiple HAproxy instances (if multiple instances are used). Default: `[ 'haproxy' ]`

#### Define: `haproxy::defaults`

This type will setup a additional defaults configuration block inside the haproxy.cfg file on an haproxy load balancer. A new default configuration block resets all defaults of prior defaults configuration blocks. [Further documentation](https://cbonte.github.io/haproxy-dconv/configuration-1.5.html#4) of what options are allowed in defaults sections. Listener, Backends, Frontends and Balancermember can be configured behind a default configuration block by setting the defaults parameter to the corresponding defaults name.

##### Parameters (all optional)

* `options`: A hash or array of hashes of options that are inserted into the defaults configuration block.

* `sort_options_alphabetic`: Sort options either alphabetic or custom like haproxy internal sorts them. Defaults to true.

* `instance`: When using `haproxy::instance` to run multiple instances of Haproxy on the same machine, this indicates which instance.  Defaults to "haproxy".

## Limitations

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
