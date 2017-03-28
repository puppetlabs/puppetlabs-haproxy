# == Class: haproxy::globals
#
# For global configuration options used by all haproxy instances.
#
# === Parameters
#
# [*sort_options_alphabetic*]
#   Sort options either alphabetic or custom like haproxy internal sorts them.
#   Defaults to true.
#
class haproxy::globals (
  Boolean $sort_options_alphabetic = true,
) {
}
