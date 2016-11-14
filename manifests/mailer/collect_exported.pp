# Private define
define haproxy::mailer::collect_exported {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  Haproxy::Mailer <<| mailers_name == $name |>>
}
