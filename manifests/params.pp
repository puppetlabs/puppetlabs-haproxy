# == Class: haproxy::params
#
# This is a container class holding default parameters for for haproxy class.
#  currently, only the Redhat family is supported, but this can be easily
#  extended by changing package names and configuration file paths.
#
class haproxy::params {
  case $osfamily {
    Redhat: {
      $global_options   = {
        'log'     => "${::ipaddress} local0",
        'chroot'  => '/var/lib/haproxy',
        'pidfile' => '/var/run/haproxy.pid',
        'maxconn' => '4000',
        'user'    => 'haproxy',
        'group'   => 'haproxy',
        'daemon'  => '',
        'stats'   => 'socket /var/lib/haproxy/stats'
      }
      $defaults_options = {
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
        'maxconn' => '8000'
      }
      $http_stats_enable  = false
      $http_stats_bind    = '0.0.0.0'
      $http_stats_port    = '1936'
      $http_stats_user    = 'stats'
      $http_stats_pass    = 'stats'
      $http_stats_options = {
        'mode'    => 'http',
        'stats'   => [
          'enable',
          'hide-version',
          'realm Haproxy\ Statistics',
          'uri /',
        ]
      }
    }
    Debian: {
      $global_options   = {
        'log'     => "${::ipaddress} local0",
        'chroot'  => '/var/lib/haproxy',
        'pidfile' => '/var/run/haproxy.pid',
        'maxconn' => '4000',
        'user'    => 'haproxy',
        'group'   => 'haproxy',
        'daemon'  => '',
        'stats'   => 'socket /var/lib/haproxy/stats'
      }
      $defaults_options = {
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
        'maxconn' => '8000'
      }
      $http_stats_enable  = false
      $http_stats_bind    = '0.0.0.0'
      $http_stats_port    = '1936'
      $http_stats_user    = 'stats'
      $http_stats_pass    = 'stats'
      $http_stats_options = {
        'mode'    => 'http',
        'stats'   => [
          'enable',
          'hide-version',
          'realm Haproxy\ Statistics',
          'uri /',
        ]
      }
    }
    Archlinux: {
      $global_options  = {
        'log'     => "${::ipaddress} local0",
        'chroot'  => '/var/lib/haproxy',
        'pidfile' => '/var/run/haproxy.pid',
        'maxconn' => '4000',
        'user'    => 'haproxy',
        'group'   => 'haproxy',
        'daemon'  => '',
        'stats'   => 'socket /var/lib/haproxy/stats'
      }
      $defaults_options = {
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
        'maxconn' => '8000'
      }
      $http_stats_enable  = false
      $http_stats_bind    = '0.0.0.0'
      $http_stats_port    = '1936'
      $http_stats_user    = 'stats'
      $http_stats_pass    = 'stats'
      $http_stats_options = {
        'mode'    => 'http',
        'stats'   => [
          'enable',
          'hide-version',
          'realm Haproxy\ Statistics',
          'uri /',
        ]
      }
    }
    default: { fail("The $::osfamily operating system is not supported with the haproxy module") }
  }
}
