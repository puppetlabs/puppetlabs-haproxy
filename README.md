# haproxy


#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with haproxy](#setup)
    * [Beginning with haproxy](#beginning-with-haproxy)
4. [Usage - Configuration options and additional functionality](#usage)
    * [Configure HAProxy options](#configure-haproxy-options)
    * [HAProxy and Software Collections](#haproxy-and-software-collections)
    * [Configure HAProxy daemon listener](#configure-haproxy-daemon-listener)
    * [Configure multi-network daemon listener](#configure-multi-network-daemon-listener)
    * [Configure HAProxy load-balanced member nodes](#configure-haproxy-load-balanced-member-nodes)
    * [Configure a load balancer with exported resources](#configure-a-load-balancer-with-exported-resources)
    * [Set up a frontend service](#set-up-a-frontend-service)
    * [Set up a backend service](#set-up-a-backend-service)
    * [Set up a resolver](#set-up-a-resolver)
    * [Configure multiple haproxy instances on one machine](#configure-multiple-haproxy-instances-on-one-machine)
    * [Manage a map file](#manage-a-map-file)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
6. [Limitations - OS compatibility, etc.](#limitations)
7. [Development - Guide for contributing to the module](#development)

## Overview

The haproxy module lets you use Puppet to install, configure, and manage HAProxy.

## Module Description

HAProxy is a daemon for load-balancing and proxying TCP- and HTTP-based services. This module lets you use Puppet to configure HAProxy servers and backend member servers.

## Setup

### Beginning with haproxy

The simplest HAProxy configuration consists of a server that listens on a port and balances against some other nodes:

~~~puppet
node 'haproxy-server' {
  include ::haproxy
  haproxy::listen { 'puppet00':
    collect_exported => false,
    ipaddress        => $::ipaddress,
    ports            => '8140',
  }
  haproxy::balancermember { 'server00':
    listening_service => 'puppet00',
    server_names      => 'server00.example.com',
    ipaddresses       => '10.0.0.10',
    ports             => '8140',
    options           => 'check',
  }
  haproxy::balancermember { 'server01':
    listening_service => 'puppet00',
    server_names      => 'server01.example.com',
    ipaddresses       => '10.0.0.11',
    ports             => '8140',
    options           => 'check',
  }
}
~~~

## Usage

### Configure HAProxy options

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

### HAProxy and Software Collections

To use this module with a software collection such as
[rh-haproxy18](https://www.softwarecollections.org/en/scls/rhscl/rh-haproxy18/)
you will need to set a few extra parameters like so:

~~~puppet
class { 'haproxy':
  package_name        => 'rh-haproxy18',
  config_dir          => '/etc/opt/rh/rh-haproxy18/haproxy',
  config_file         => '/etc/opt/rh/rh-haproxy18/haproxy/haproxy.cfg',
  config_validate_cmd => '/bin/scl enable rh-haproxy18 "haproxy -f % -c"',
  service_name        => 'rh-haproxy18-haproxy',
}
~~~

### Configure HAProxy daemon listener

To export the resource for a balancermember and collect it on a single HAProxy load balancer server:

~~~puppet
haproxy::listen { 'puppet00':
  ipaddress => $::ipaddress,
  ports     => '8140',
  mode      => 'tcp',
  options   => {
    'option'  => [
      'tcplog',
    ],
    'balance' => 'roundrobin',
  },
}
~~~

### Configure multi-network daemon listener

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

### Configure HAProxy load-balanced member nodes

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

### Configure a load balancer with exported resources

Install and configure an HAProxy service listening on port 8140 and balanced against all collected nodes:

~~~puppet
node 'haproxy-server' {
  include ::haproxy
  haproxy::listen { 'puppet00':
    ipaddress => $::ipaddress,
    ports     => '8140',
  }
}

node /^server\d+/ {
  @@haproxy::balancermember { $::fqdn:
    listening_service => 'puppet00',
    server_names      => $::hostname,
    ipaddresses       => $::ipaddress,
    ports             => '8140',
    options           => 'check',
  }
}
~~~

The resulting HAProxy service uses storeconfigs to collect and realize balancermember servers, and automatically collects configurations from backend servers. The backend nodes export their HAProxy configurations to the Puppet Server, which then distributes them to the HAProxy server.

### Set up a frontend service

This example routes traffic from port 8140 to all balancermembers added to a backend with the title 'puppet_backend00':

~~~puppet
haproxy::frontend { 'puppet00':
  ipaddress     => $::ipaddress,
  ports         => '8140',
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
  ports         => '8140',
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

### Set up a backend service

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

### Set up a resolver

Note: This is only available on haproxy 1.6+

~~~puppet
# Need to start with an init-addr parameter set to none and enable runtime DNS resolution.
class { 'haproxy':
...
  defaults_options => {
    'default-server' => 'init-addr none',
...
  },
}

# Declare the resolver
haproxy::resolver { 'puppet00':
  nameservers           => {
    'dns1' => '192.168.56.1:53',
    'dns2' => '192.168.56.2:53'
  },
  hold                  => {
    'nx'    => '30s',
    'valid' => '10s'
  },
  resolve_retries       => 3,
  timeout               => {
    'retry' => '1s'
  },
  accepted_payload_size => 512,
}

# Setup the balancermember to use the resolver for DNS resolution
haproxy::balancermember { 'haproxy':
  listening_service => 'puppet00',
  ports             => '8140',
  server_names      => ['server01', 'server02'],
  ipaddresses       => ['server01', 'server02'],
  options           => 'check resolvers puppet00 resolve-prefer ipv4',
}
~~~

### Set up stick-tables for a frontend (or a backend)

~~~puppet
haproxy::backend { 'backend01':
  options => [
    { 'stick-table' => 'type ip size 1 nopurge peers LB' },
    { 'stick'       => 'on dst' },
  ],
}
~~~

This adds the backend options to the configuration block in the same order as they appear within the array.

### Configure multiple haproxy instances on one machine

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

## Reference

For information on the classes and types, see the [REFERENCE.md](https://github.com/puppetlabs/puppetlabs-haproxy/blob/main/REFERENCE.md)

## Limitations

For an extensive list of supported operating systems, see [metadata.json](https://github.com/puppetlabs/puppetlabs-haproxy/blob/main/metadata.json)

## Development

Acceptance tests for this module leverage [puppet_litmus](https://github.com/puppetlabs/puppet_litmus).
To run the acceptance tests follow the instructions [here](https://github.com/puppetlabs/puppet_litmus/wiki/Tutorial:-use-Litmus-to-execute-acceptance-tests-with-a-sample-module-(MoTD)#install-the-necessary-gems-for-the-module).
You can also find a tutorial and walkthrough of using Litmus and the PDK on [YouTube](https://www.youtube.com/watch?v=FYfR7ZEGHoE).

If you run into an issue with this module, or if you would like to request a feature, please [file a ticket](https://tickets.puppetlabs.com/browse/MODULES/).
Every Monday the Puppet IA Content Team has [office hours](https://puppet.com/community/office-hours) in the [Puppet Community Slack](http://slack.puppet.com/), alternating between an EMEA friendly time (1300 UTC) and an Americas friendly time (0900 Pacific, 1700 UTC).

If you have problems getting this module up and running, please [contact Support](http://puppetlabs.com/services/customer-support).

If you submit a change to this module, be sure to regenerate the reference documentation as follows:

```bash
puppet strings generate --format markdown --out REFERENCE.md
```
