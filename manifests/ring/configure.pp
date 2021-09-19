#
# @param instance
#   Hash [param*]
#
# === Authors
#
# Erwin Dwight S. Paler <erwin.dwight.paler@gmail.com>
#
class haproxy::ring::configure (
  Hash $instance = {},
) {

  include ::haproxy

  $instance.each |$name, $params| {
    haproxy::ring {
      $name:
        * => $params,
        ;
    }
  }
}
