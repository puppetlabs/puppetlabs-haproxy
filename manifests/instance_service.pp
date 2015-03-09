# == Define: haproxy::instance_service
#
# Set up the environment for an haproxy service.
#   * Associate an haproxy instance with the haproxy package it should use.
#   * Create the start/restart/stop functions needed by Service[].
# In other words: sets things up so that Service[$instance_name] will work.
#
# In particular:
#
# * Create a link to the binary an instance will be using. This
#   way each instance can link to a different binary.
#   If you have an instance called "foo", you know "haproxy-foo"
#   is a link to the binary it should be using.
# * Create an init.d file named after the instance. This way
#   Service[$instance] can start/restart the service.
#
# This is just one way to do this. You may want to do it
# some other way. That is why this isn't done automatically as
# part of haproxy::instance.
# 
#
# FIXME: This hasn't been tested on FreeBSD.
# FIXME: This should take advantage of systemd instead of using init.d.
# FIXME: Update haproxy.init to sync it up with the latest packaged script.
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
define haproxy::instance_service (
  $haproxy_package = 'haproxy',
  $bindir = '/opt/haproxy',
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
  if $haproxy_package == 'haproxy' {
    $haproxy_link = "${bindir}/haproxy"
    $haproxy_target = '/usr/sbin/haproxy'
  } else {
    $haproxy_link = "${bindir}/haproxy-${title}"
    $haproxy_target = "/opt/${haproxy_package}/sbin/haproxy"
  }
  file { $haproxy_link:
    ensure => link,
    target => $haproxy_target,
  }

  # Create an init.d file so that "service haproxy-$instance start" works.
  # This is not required if the standard instance is being used.
  if ($title == 'haproxy') or ($haproxy_package == 'haproxy') {
  } else {
    # TODO(tlim): Works for CentOS7 but should be reworked to use systemd.
    $initfile = "/etc/init.d/haproxy-${title}"
    file { $initfile:
      ensure => file,
      mode   => '0744',
      owner  => 'root',
      group  => 'root',
      source => "puppet:///modules/${module_name}/haproxy.init",
    }
    File[$haproxy_link] -> File[$initfile]
  }

  Package[$haproxy_package] -> File[$bindir] -> File[$haproxy_link]
}
