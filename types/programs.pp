type Haproxy::Programs = Hash[String, Struct[{
  command               => String[1],
  Optional[user]        => String[1],
  Optional[group]       => String[1],
  Optional[options]     => String[1],
  Optional[instance]    => String[1],
  Optional[config_file] => Stdlib::Absolutepath,
}]]

