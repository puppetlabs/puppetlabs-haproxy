# == Define: haproxy::instance_service
#
# Set up the environment for an haproxy service.
#   * Associate an haproxy instance with the haproxy package it should use.
#   * Create the start/restart/stop functions needed by Service[].
# In other words: sets things up so that Service[$instance_name] will work.
#
# In particular:
# * Create a link to the binary an instance will be using. This
#   way each instance can link to a different binary.
#   If you have an instance called "foo", you know "haproxy-foo"
#   is a link to the binary it should be using.
# * Create an init.d file named after the instance. This way
#   Service[$instance] can start/restart the service.
#
# NOTE:
# This manifest is just one example of how to set up Service[$instance].
# Other sites may choose to do it very differently. In that case, do
# not call haproxy::instance_service; write your own module.  The only
# requirement is that before haproxy::instance{$instance:} is called,
# Service[$instance] must be defined.
#
# FIXME: This hasn't been tested on FreeBSD.
# FIXME: This should take advantage of systemd when available.
#
# === Parameters
#
# [*haproxy_package*]
#   The name of the package to be installed. This is useful if
#   you package your own custom version of haproxy.
#   Defaults to 'haproxy'
#
# [*bindir*]
#   Where to put symlinks to the binary used for each instance.
#   Defaults to '/opt/haproxy'
#
# [*haproxy_init_source*]
#   The init.d script that will start/restart/reload this instance.
#
define haproxy::instance_service (
  $haproxy_init_source = undef,
  $haproxy_unit_template = undef,
  $haproxy_package = 'haproxy',
  $bindir = '/opt/haproxy/bin',
) {

  ensure_resource('package', $haproxy_package, {
    'ensure' => 'present',
  })

  # Manage the parent directory.
  ensure_resource('file', $bindir, {
    ensure => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0744',
  })

  # Create a link named after the instance. This just makes it easier
  # to manage difference instances using different versions of haproxy.
  # If you have an instance called "foo", you know "haproxy-foo"
  # is the binary.
  $haproxy_link = "${bindir}/haproxy-${title}"
  if $haproxy_package == 'haproxy' {
    $haproxy_target = '/usr/sbin/haproxy'
  } else {
    $haproxy_target = "/opt/${haproxy_package}/sbin/haproxy"
  }
  file { $haproxy_link:
    ensure => link,
    target => $haproxy_target,
  }

  # Create init.d or systemd files so that "service haproxy-$instance start"
  # or "systemd start haproxy-$instance" works.
  # This is not required if the standard instance is being used.
  if ($title == 'haproxy') or ($haproxy_package == 'haproxy') {
  } else {
    $initfile = "/etc/init.d/haproxy-${title}"
    if $::osfamily == 'RedHat' and $::operatingsystemmajrelease == '6' {

      # init.d:
      validate_string($haproxy_init_source)
      file { $initfile:
        ensure => file,
        mode   => '0744',
        owner  => 'root',
        group  => 'root',
        source => $haproxy_init_source,
      }
      File[$haproxy_link] -> File[$initfile]

    } else {

      # systemd:
      validate_string($haproxy_unit_template)
      if $haproxy_package == 'haproxy' {
        $wrapper = '/usr/sbin/haproxy-systemd-wrapper'
      } else {
        $wrapper = "/opt/${haproxy_package}/sbin/haproxy-systemd-wrapper"
      }

      $unitfile = "/usr/lib/systemd/system/haproxy-${title}.service"
      file { $unitfile:
        ensure  => file,
        mode    => '0744',
        owner   => 'root',
        group   => 'root',
        content => template($haproxy_unit_template),
        notify  => Exec['systemctl daemon-reload'],
      }
      if (!defined(Exec['systemctl daemon-reload'])) {
        exec { 'systemctl daemon-reload':
          command     => 'systemctl daemon-reload',
          path        => '/bin:/usr/bin:/usr/local/bin:/sbin:/usr/sbin',
          refreshonly => true,
          before      => Service["haproxy-${title}"],
        }
      }
      File[$haproxy_link] -> File[$unitfile]
      # Clean up in case the old init.d-style file is still around.
      file { $initfile:
        ensure => absent,
        before => Service["haproxy-${title}"],
      }

    }
  }

  Package[$haproxy_package] -> File[$bindir] -> File[$haproxy_link]
}
