# == Define Resource Type: haproxy::mapfile
#
# Manage an HAProxy map file as documented in
# https://cbonte.github.io/haproxy-dconv/configuration-1.5.html#7.3.1-map
# A map file contains one key + value per line. These key-value pairs are
# specified in the `mappings` array.
#
# === Parameters
#
# [*name*]
#   The namevar of the defined resource type is the filename of the map file
#   (without any extension), relative to the `haproxy::config_dir` directory.
#   A '.map' extension will be added automatically.
#
# [*mappings*]
#   An array of mappings for this map file. Array elements may be Hashes with a
#   single key-value pair each (preferably) or simple Strings. Default: `[]`
#
# [*ensure*]
#   The state of the underlying file resource, either 'present' or 'absent'.
#   Default: 'present'
#
# [*owner*]
#   The owner of the underlying file resource. Defaut: 'root'
#
# [*group*]
#   The group of the underlying file resource. Defaut: 'root'
#
# [*mode*]
#   The mode of the underlying file resource. Defaut: '0644'
#
# [*instances*]
#   Array of managed HAproxy instance names to notify (restart/reload) when the
#   map file is updated. This is so that the same map file can be used with
#   multiple HAproxy instances. Default: `[ 'haproxy' ]`
#
define haproxy::mapfile (
  $mappings  = [],
  $ensure    = 'present',
  $owner     = 'root',
  $group     = 'root',
  $mode      = '0644',
  $instances = [ 'haproxy' ],
) {
  $mapfile_name = $title

  validate_re($ensure, '^present|absent$', "Haproxy::Mapfile[${mapfile_name}]: '${ensure}' is not supported for ensure. Allowed values are 'present' and 'absent'.")
  validate_array($mappings)
  validate_array($instances)

  $_instances = flatten($instances)

  file { "haproxy_mapfile_${mapfile_name}":
    ensure  => $ensure,
    owner   => $owner,
    group   => $group,
    mode    => $mode,
    content => template('haproxy/haproxy_mapfile.erb'),
    path    => "${haproxy::config_dir}/${mapfile_name}.map",
    notify  => Haproxy::Service[$_instances],
  }
}
