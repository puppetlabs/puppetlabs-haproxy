# haproxy

[![Build Status](https://travis-ci.org/puppetlabs/puppetlabs-haproxy.svg?branch=master)](https://travis-ci.org/puppetlabs/puppetlabs-haproxy)

####Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with haproxy](#setup)
    * [What haproxy affects](#what-haproxy-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with haproxy](#beginning-with-haproxy)
4. [Usage - Configuration options and additional functionality](#usage)
    * [Classes and Defined Types](#classes-and-defined-types)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

##Overview

HAProxy is an HA proxying daemon for load-balancing to clustered services. It can proxy TCP directly, or other kinds of traffic such as HTTP.

##Module Description

##Setup

###What haproxy affects

* A list of files, packages, services, or operations that the module will alter, impact, or execute on the system it's installed on.
* This is a great place to stick any warnings.
* Can be in list or paragraph form.

###Setup Requirements **OPTIONAL**

If your module requires anything extra before setting up (pluginsync enabled, etc.), mention it here. 

###Beginning with haproxy

To install and configure HAProxy server listening on port 8140 and balance against two nodes.

```puppet
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
```

###Configuring a loadbalancer with exported resources

To install and configure HAProxy server listening on port 8140 and balance against all collected nodes. This haproxy uses storeconfigs to collect and realize balancer member servers on a load balancer server.

```puppet
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
```

##Usage

##Reference

###List of classes and defined types

####Public classes and defined types

* Class `haproxy`: Main configuration class
* Define `haproxy::listen`: Creates a listen entry in the config
* Define `haproxy::frontend`: Creates a frontend entry in the config
* Define `haproxy::backend`: Creates a backend entry in the config
* Define `haproxy::balancermember`: Creates server entries for listen or backend blocks.
* Define `haproxy::userlist`: Creates a userlist entry in the config

####Private classes and defined types

* Class `haproxy::params`: Per-operatingsystem defaults.
* Class `haproxy::install`: Installs packages.
* Class `haproxy::config`: Configures haproxy.cfg.
* Class `haproxy::service`: Manages service.
* Define `haproxy::balancermember::collect_exported`: Collects exported balancermembers

###Class: `haproxy`

Description?

#### Parameters

#####`custom_fragment`
Allows arbitrary HAProxy configuration to be passed through to support additional configuration not available via parameters, or to short-circute the defined resources such as haproxy::listen when an operater would rather just write plain configuration. Accepts a string (eg, output from the template() function). Defaults to undef

#####`defaults_options`
A hash of all the haproxy defaults options. If you want to specify more than one option (i.e. multiple timeout or stats options), pass those options as an array and you will get a line for each of them in the resultant haproxy.cfg file.

#####`global_options`
A hash of all the haproxy global options. If you want to specify more than one option (i.e. multiple timeout or stats options), pass those options as an array and you will get a line for each of them in the resultant haproxy.cfg file.

#####`package_ensure`
Chooses whether the haproxy package should be installed or uninstalled. Defaults to 'present'

#####`package_name`
The package name of haproxy. Defaults to 'haproxy'

#####`restart_command`
Command to use when restarting the on config changes.  Passed directly as the `'restart'` parameter to the service resource.  Defaults to undef i.e. whatever the service default is.

#####`service_ensure`
Chooses whether the haproxy service should be running & enabled at boot, or stopped and disabled at boot. Defaults to 'running'

#####`service_manage`
Chooses whether the haproxy service state should be managed by puppet at all. Defaults to true

#### Examples

Description?

```puppet
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
    'option'  => 'redispatch',
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
```

###Defined type: `haproxy::listen`

This type will setup a listening service configuration block inside the haproxy.cfg file on an haproxy load balancer. Each listening service configuration needs one or more load balancer member server (that can be declared with the `haproxy::balancermember` defined resource type). Using storeconfigs, you can export the `haproxy::balancermember` resources on all load balancer member servers, and then collect them on a single haproxy load balancer server.

####Parameters

#####`bind_options`
An array of options to be specified after the bind declaration in the listening serivce's configuration block.

#####`collect_exported`
Boolean, default 'true'. True means 'collect exported @@balancermember resources' (for the case when every balancermember node exports itself), false means 'rely on the existing declared balancermember resources' (for the case when you know the full set of balancermembers in advance and use haproxy::balancermember with array arguments, which allows you to deploy everything in 1 run)

#####`ipaddress`
The ip address the proxy binds to. Empty addresses, '\*', and '0.0.0.0' mean that the proxy listens to all valid addresses on the system.

#####`mode`
The mode of operation for the listening service. Valid values are undef, 'tcp', 'http', and 'health'.

#####`name`
The namevar of the defined resource type is the listening service's name. This name goes right after the 'listen' statement in haproxy.cfg

#####`options`
A hash of options that are inserted into the listening service configuration block.

#####`ports`
Ports on which the proxy will listen for connections on the ip address specified in the ipaddress parameter. Accepts either a single comma-separated string or an array of strings which may be ports or hyphenated port ranges.

#### Examples

Exporting the resource for a balancer member:

```puppet
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
```

###Define type: `haproxy::frontend`

This type will setup a frontend service configuration block inside the haproxy.cfg file on an haproxy load balancer.

####Parameters

#####`bind_options`
An array of options to be specified after the bind declaration in the bind's configuration block.

#####`ipaddress`
The ip address the proxy binds to. Empty addresses, '\*', and '0.0.0.0' mean that the proxy listens to all valid addresses on the system.

#####`mode`
The mode of operation for the frontend service. Valid values are undef, 'tcp', 'http', and 'health'.

#####`name`
The namevar of the defined resource type is the frontend service's name. This name goes right after the 'frontend' statement in haproxy.cfg

#####`options`
A hash of options that are inserted into the frontend service configuration block.

#####`ports`
Ports on which the proxy will listen for connections on the ip address specified in the ipaddress parameter. Accepts either a single comma-separated string or an array of strings which may be ports or hyphenated port ranges.

####Examples

Exporting the resource for a balancer member:

```puppet
haproxy::frontend { 'puppet00':
  ipaddress     => $::ipaddress,
  ports         => '18140',
  mode          => 'tcp',
  bind_options  => 'accept-proxy',
  options       => {
    'option'          => [
      'tcplog',
      'accept-invalid-http-request',
    ],
    'timeout client'  => '30',
    'balance'         => 'roundrobin',
  },
}
```

###Define Type: `haproxy::backend`

This type will setup a backend service configuration block inside the haproxy.cfg file on an haproxy load balancer. Each backend service needs one or more backend member servers (that can be declared with the haproxy::balancermember defined resource type). Using storeconfigs, you can export the haproxy::balancermember resources on all load balancer member servers and then collect them on a single haproxy load balancer server.

####Parameters

#####`name`
The namevar of the defined resource type is the backend service's name. This name goes right after the 'backend' statement in haproxy.cfg

#####`options`
A hash of options that are inserted into the backend configuration block.

#####`collect_exported`
Boolean, default 'true'. True means 'collect exported @@balancermember resources' (for the case when every balancermember node exports itself), false means 'rely on the existing declared balancermember resources' (for the case when you know the full set of balancermember in advance and use `haproxy::balancermember` with array arguments, which allows you to deploy everything in 1 run)

####Examples

Exporting the resource for a backend member:

```puppet
haproxy::backend { 'puppet00':
  options => {
    'option'  => [
      'tcplog',
      'ssl-hello-chk',
    ],
    'balance' => 'roundrobin',
  },
}
```

###Define Type: `haproxy::balancermember`

This type will setup a balancer member inside a listening service configuration block in /etc/haproxy/haproxy.cfg on the load balancer. currently it only has the ability to specify the instance name, ip address, port, and whether or not it is a backup. More features can be added as needed. The best way to implement this is to export this resource for all haproxy balancer member servers, and then collect them on the main haproxy load balancer.

####Parameters

#####`define_cookies`
  If true, then add "cookie SERVERID" stickiness options.
   Default false.

#####`ensure`
If the balancermember should be present or absent. Defaults to present.

#####`ipaddresses`
The ip address used to contact the balancer member server. Can be an array, see documentation to server\_names.

#####`listening_service`
The haproxy service's instance name (or, the title of the `haproxy::listen` resource). This must match up with a declared `haproxy::listen` resource.

#####`name`
The title of the resource is arbitrary and only utilized in the concat fragment name.

#####`options`
  An array of options to be specified after the server declaration
   in the listening service's configuration block.

#####`ports`
An array or commas-separated list of ports for which the balancer member will accept connections from the load balancer. Note that cookie values aren't yet supported, but shouldn't be difficult to add to the configuration. If you use an array in server\_names and ipaddresses, the same port is used for all balancermembers.

#####`server_names`
The name of the balancer member server as known to haproxy in the listening service's configuration block. This defaults to the hostname. Can be an array of the same length as ipaddresses, in which case a balancermember is created for each pair of server\_names and ipaddresses (in lockstep).

####Examples

Exporting the resource for a balancer member:

```puppet
@@haproxy::balancermember { 'haproxy':
  listening_service => 'puppet00',
  ports             => '8140',
  server_names      => $::hostname,
  ipaddresses       => $::ipaddress,
  options           => 'check',
}
```

Collecting the resource on a load balancer

```puppet
Haproxy::Balancermember <<| listening_service == 'puppet00' |>>
```

Creating the resource for multiple balancer members at once (for single-pass installation of haproxy without requiring a first pass to export the resources if you know the members in advance):

```puppet
haproxy::balancermember { 'haproxy':
  listening_service => 'puppet00',
  ports             => '8140',
  server_names      => ['server01', 'server02'],
  ipaddresses       => ['192.168.56.200', '192.168.56.201'],
  options           => 'check',
}
```

###Define Type: `haproxy::userlist`

This type will set up a userlist configuration block inside the haproxy.cfg file on an haproxy load balancer.

See http://cbonte.github.io/haproxy-dconv/configuration-1.4.html#3.4 for more info

####Parameters

#####`name`
The namevar of the define resource type is the userlist name. This name goes right after the 'userlist' statement in haproxy.cfg

#####`users`
An array of users in the userlist. See http://cbonte.github.io/haproxy-dconv/configuration-1.4.html#3.4-user

#####`groups`
An array of groups in the userlist. See http://cbonte.github.io/haproxy-dconv/configuration-1.4.html#3.4-group

####Examples

None?

##Limitations

This is where you list OS compatibility, version compatibility, etc.

##Development

Since your module is awesome, other users will want to play with it. Let them know what the ground rules for contributing are.

##Release Notes/Contributors/Etc **Optional**

If you aren't using changelog, put your release notes here (though you should consider using changelog). You may also add any additional sections you feel are necessary or important to include here. Please use the `## ` header. 
