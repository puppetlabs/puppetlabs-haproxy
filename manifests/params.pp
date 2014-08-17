# == Class: haproxy::params
#
# This is a container class holding default parameters for for haproxy class.
#  currently, only the Redhat family is supported, but this can be easily
#  extended by changing package names and configuration file paths.
#
class haproxy::params {
  case $::osfamily {
    'Archlinux', 'Debian', 'Redhat': {
      $package_name     = 'haproxy'
      $global_options   = {
        'log'     => $global_log, 
        'chroot'  => $global_chroot,
        'pidfile' => $global_pidfile, 
        'maxconn' => $global_maxconn, 
        'user'    => $global_user, 
        'group'   => $global_group, 
        'daemon'  => $global_daemon, 
        'stats'   => $global_stats, 
      }
      $defaults_options = {
        'log'     => $defaults_log, 
        'stats'   => $defaults_stats, 
        'option'  => $defaults_option, 
        'retries' => $defaults_retries, 
        'timeout' => [
          "http-request $defaults_timeout_http_request",
          "queue $defaults_timeout_queue",
          "connect $defaults_timeout_connect",
          "client $defaults_timeout_client",
          "server $defaults_timeout_server",
          "check $defaults_timeout_check",
        ],
        'maxconn' => $defaults_maxconn, 
      }
    }
    default: { fail("The ${::osfamily} operating system is not supported with the haproxy module") }
  }
}
