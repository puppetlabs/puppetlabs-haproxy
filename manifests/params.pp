# == Class: haproxy::params
#
# This is a container class holding default parameters for haproxy class.
#  currently, only the Redhat, Debian and Archlinux families are supported, 
# but this can be easily extended by changing package names and configuration 
# file paths.
#
class haproxy::params {

  $package_name      = 'haproxy'
  $_global_log       = "${::ipaddress} local0"
  $_global_chroot    = '/var/lib/haproxy'
  $_global_pidfile   = '/var/run/haproxy.pid'
  $_global_maxconn   = '4000'
  $_global_user      = 'haproxy'
  $_global_group     = 'haproxy'
  $_global_daemon    = ''
  $_global_stats     = 'socket /var/lib/haproxy/stats'
  $_defaults_log     = 'global'
  $_defaults_stats   = 'enable'
  $_defaults_option  = 'redispatch'
  $_defaults_retries = '3'
  $_defaults_timeout_http_request = '10s'
  $_defaults_timeout_queue   = '1m'
  $_defaults_timeout_connect = '10s'
  $_defaults_timeout_client  = '1m'
  $_defaults_timeout_server  = '1m'
  $_defaults_timeout_check   = '10s'
  $_defaults_maxconn = '8000'

  $_global_options   = {
    'log'     => "${::ipaddress} local0",
    'chroot'  => '/var/lib/haproxy',
    'pidfile' => '/var/run/haproxy.pid',
    'maxconn' => '4000',
    'user'    => 'haproxy',
    'group'   => 'haproxy',
    'daemon'  => '',
    'stats'   => 'socket /var/lib/haproxy/stats'
  }
  $_defaults_options = {
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

}
