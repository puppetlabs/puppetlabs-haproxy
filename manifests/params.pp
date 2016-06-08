# == Class: haproxy::params
#
# This is a container class holding default parameters for for haproxy class.
#  currently, only the Redhat family is supported, but this can be easily
#  extended by changing package names and configuration file paths.
#
class haproxy::params {
  # XXX: This will change to true in the next major release
  $merge_options = false

  $service_options  = "ENABLED=1\n"  # Only used by Debian.
  $sysconfig_options = 'OPTIONS=""' #Only used by Redhat/CentOS etc

  case $::osfamily {
    'Archlinux', 'Debian', 'Redhat', 'Gentoo', 'Suse' : {
      $package_name      = 'haproxy'
      $global_options    = {
        'log'     => "${::ipaddress} local0",
        'chroot'  => '/var/lib/haproxy',
        'pidfile' => '/var/run/haproxy.pid',
        'maxconn' => '4000',
        'user'    => 'haproxy',
        'group'   => 'haproxy',
        'daemon'  => '',
        'stats'   => 'socket /var/lib/haproxy/stats'
      }
      $defaults_options  = {
        'log'     => 'global',
        'stats'   => 'enable',
        'option'  => [ 'redispatch' ],
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
      # Single instance:
      $config_dir        = '/etc/haproxy'
      $config_file       = '/etc/haproxy/haproxy.cfg'
      $manage_config_dir = true
      # Multi-instance:
      $config_dir_tmpl   = '/etc/<%= @instance_name %>'
      $config_file_tmpl  = "${config_dir_tmpl}/<%= @instance_name %>.cfg"
    }
    'FreeBSD': {
      $package_name      = 'haproxy'
      $global_options    = {
        'log'     => [
          '127.0.0.1 local0',
          '127.0.0.1 local1 notice',
        ],
        'chroot'  => '/usr/local/haproxy',
        'pidfile' => '/var/run/haproxy.pid',
        'maxconn' => '4096',
        'daemon'  => '',
      }
      $defaults_options  = {
        'log'        => 'global',
        'mode'       => 'http',
        'option'     => [
          'httplog',
          'dontlognull',
        ],
        'retries'    => '3',
        'redispatch' => '',
        'maxconn'    => '2000',
        'contimeout' => '5000',
        'clitimeout' => '50000',
        'srvtimeout' => '50000',
      }
      # Single instance:
      $config_dir        = '/usr/local/etc'
      $config_file       = '/usr/local/etc/haproxy.conf'
      $manage_config_dir = false
      # Multi-instance:
      $config_dir_tmpl  = '/usr/local/etc/<%= @instance_name %>'
      $config_file_tmpl = "${config_dir_tmpl}/<%= @instance_name %>.conf"
    }
    default: { fail("The ${::osfamily} operating system is not supported with the haproxy module") }
  }
}

# TODO: test that the $config_file generated for FreeBSD instances
#  and RedHat instances is as expected.
