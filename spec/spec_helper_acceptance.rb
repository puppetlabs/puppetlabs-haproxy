require 'beaker-pe'
require 'beaker-puppet'
require 'beaker-rspec'
require 'beaker/puppet_install_helper'

run_puppet_install_helper
configure_type_defaults_on(hosts)

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    # Install module and dependencies
    puppet_module_install(source: proj_root, module_name: 'haproxy')
    hosts.each do |host|
      on host, puppet('module', 'install', 'puppetlabs-stdlib'), acceptable_exit_codes: [0, 1]
      on host, puppet('module', 'install', 'puppetlabs-concat'), acceptable_exit_codes: [0, 1]
      if fact('osfamily') == 'RedHat'
        on host, puppet('module', 'install', 'stahnma/epel'), acceptable_exit_codes: [0, 1]
      end
      if fact('operatingsystem') == 'Debian'
        on host, puppet('module', 'install', 'puppetlabs-apt'), acceptable_exit_codes: [0, 1]
        apply_manifest(%(
          include apt
          include apt::backports
        ))
      end
      pp = <<-PUPPETCODE
        package { 'socat': ensure => present, }
        package { 'screen': ensure => present, }
        if $::osfamily == 'RedHat' {
          if $::operatingsystemmajrelease == '5' or ($::operatingsystem == 'OracleLinux' and $::operatingsystemmajrelease == '6'){
            class { 'epel':
              epel_baseurl => "http://osmirror.delivery.puppetlabs.net/epel${::operatingsystemmajrelease}-\$basearch/RPMS.all",
              epel_mirrorlist => "http://osmirror.delivery.puppetlabs.net/epel${::operatingsystemmajrelease}-\$basearch/RPMS.all",
              before => Package['socat'],
            }
          } else {
            class { 'epel':
              before => Package['socat'],
            }
          }
          service { 'iptables': ensure => stopped, }
          exec { 'setenforce 0':
            path   => ['/bin','/usr/bin','/sbin','/usr/sbin'],
            onlyif => 'which getenforce && getenforce | grep Enforcing',
          }
        }
        if ($::osfamily == 'RedHat' and $::operatingsystemmajrelease == '7') or ($::osfamily == 'Debian' and ($::operatingsystemmajrelease == '9' or $::operatingsystemmajrelease == '18.04')) {
          # For `netstat` for serverspec
          package { 'net-tools': ensure => present, }
        }
      PUPPETCODE
      apply_manifest(pp, catch_failures: true)

      ['5556', '5557'].each do |port|
        content = "socat -v tcp-l:#{port},reuseaddr,fork system:\"printf \\'HTTP/1.1 200 OK\r\n\r\nResponse on #{port}\\'\",nofork"
        create_remote_file(host, "/root/script-#{port}.sh", content)
        shell(%(/usr/bin/screen -dmS script-#{port} sh /root/script-#{port}.sh))
        sleep 1
        shell(%(netstat -tnl|grep ':#{port}'))
      end
    end
  end

  # FM-5470, this was added to reset failed count and work around puppet 3.x
  if (fact('operatingsystem') == 'SLES' && fact('operatingsystemmajrelease') == '12') || (fact('osfamily') == 'RedHat' && fact('operatingsystemmajrelease') == '7')
    c.after :each do
      # not all tests have a haproxy service, so the systemctl call can fail,
      # but we don't care as we only need to reset when it does.
      shell('systemctl reset-failed haproxy.service || true')
    end
  end
end
