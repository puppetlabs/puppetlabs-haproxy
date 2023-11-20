# @summary
#   This type will setup a backend service configuration block inside the
#   haproxy.cfg file on an haproxy load balancer. 
# @note
#   Each backend service needs one
#   or more backend member servers (that can be declared with the
#   haproxy::balancermember defined resource type).  Using storeconfigs, you can
#   export the haproxy::balancermember resources on all load balancer member
#   servers and then collect them on a single haproxy load balancer server.
#
# @note
#   Currently requires the puppetlabs/concat module on the Puppet Forge and
#   uses storeconfigs on the Puppet Server to export/collect resources
#   from all backend members.
#
# @param section_name
#    This name goes right after the 'backend' statement in haproxy.cfg
#    Default: $name (the namevar of the resource).
#
# @param mode
#   The mode of operation for the backend service. Valid values are undef,
#    'tcp', 'http', and 'health'.
#
# @param description
#   Allows to add a sentence to describe the related object in the HAProxy HTML
#   stats page. The description will be printed on the right of the object name
#   it describes. Usefull in huge environments
#
# @param options
#   A hash of options that are inserted into the backend configuration block.
#
# @param collect_exported
#   Boolean, default 'true'. True means 'collect exported @@balancermember
#    resources' (for the case when every balancermember node exports itself),
#    false means 'rely on the existing declared balancermember resources' (for
#    the case when you know the full set of balancermember in advance and use
#    haproxy::balancermember with array arguments, which allows you to deploy
#    everything in 1 run)
#
# @param config_file
#   Optional. Path of the config file where this entry will be added.
#   Assumes that the parent directory exists.
#   Default: $haproxy::params::config_file
#
# @param sort_options_alphabetic
#   Sort options either alphabetic or custom like haproxy internal sorts them.
#   Defaults to undef (picking true from $haproxy::globals::sort_options_alphabetic).
#
# @param defaults
#   Name of the defaults section this backend will use.
#   Defaults to undef which means the global defaults section will be used.
# 
# @param instance
#   Optional. Defaults to 'haproxy'
#
# @example
#  haproxy::backend { 'puppet00':
#    options   => {
#      'option'  => [
#        'tcplog',
#        'ssl-hello-chk'
#      ],
#      'balance' => 'roundrobin'
#    },
#  }
#
# === Authors
#
# Gary Larizza <gary@puppetlabs.com>
# Jeremy Kitchen <jeremy@nationbuilder.com>
#
define haproxy::backend (
  Optional[Enum['tcp', 'http', 'health']] $mode                     = undef,
  Boolean                                 $collect_exported         = true,
  Variant[Hash, Array[Hash]]              $options                  = {
    'balance' => 'roundrobin',
  },
  String                                  $instance                 = 'haproxy',
  String[1]                               $section_name             = $name,
  Optional[Boolean]                       $sort_options_alphabetic  = undef,
  Optional[String]                        $description              = undef,
  Optional[String]                        $defaults                 = undef,
  Optional[Stdlib::Absolutepath]          $config_file              = undef,
) {
  if defined(Haproxy::Listen[$section_name]) {
    fail("An haproxy::listen resource was discovered with the same name (${section_name}) which is not supported")
  }

  include haproxy::params

  if $instance == 'haproxy' {
    $instance_name = 'haproxy'
    $_config_file = pick($config_file, $haproxy::config_file)
  } else {
    $instance_name = "haproxy-${instance}"
    $_config_file = pick($config_file, inline_template($haproxy::params::config_file_tmpl))
  }

  include haproxy::globals

  # See https://github.com/puppetlabs/puppetlabs-haproxy/pull/442 - when using the option 'httpchk', it must be positioned
  # before the 'http-check' directive in haproxy.cfg otherwise it will be ignored
  #
  # logic:
  # 1) if alphabetic sorting is explicitly disabled, accept that
  # 2) if the options hash contains httpchk, disable alphabetic sorting *and* log a warning
  # 3) use whats provides to this module and if that's undef, use the module default
  $picked_sort_options_alphabetic = pick($sort_options_alphabetic, $haproxy::globals::sort_options_alphabetic)
  if $picked_sort_options_alphabetic == false {
    $_sort_options_alphabetic = $picked_sort_options_alphabetic
  } else {
    if $options =~ Hash and 'option' in $options {
      if ('httpchk' in $options['option']) {
        warning('Overriding the value of $sort_options_alphabetic to "false" due to "httpchk" option defined')
        $_sort_options_alphabetic = false
      } else {
        $_sort_options_alphabetic = $picked_sort_options_alphabetic
      }
    } else {
      $_sort_options_alphabetic = $picked_sort_options_alphabetic
    }
  }

  if $defaults == undef {
    $order = "20-${section_name}-00"
  } else {
    $order = "25-${defaults}-${section_name}-01"
  }

  $parameters = {
    'section_name'             => $section_name,
    'mode'                     => $mode,
    'description'              => $description,
    '_sort_options_alphabetic' => $_sort_options_alphabetic,
    'options'                  => $options,
  }

  # Template uses: $section_name, $ipaddress, $ports, $options
  concat::fragment { "${instance_name}-${section_name}_backend_block":
    order   => $order,
    target  => $_config_file,
    content => epp('haproxy/haproxy_backend_block.epp', $parameters),
  }

  if $collect_exported {
    haproxy::balancermember::collect_exported { $section_name: }
  }
  # else: the resources have been created and they introduced their
  # concat fragments. We don't have to do anything about them.
}
