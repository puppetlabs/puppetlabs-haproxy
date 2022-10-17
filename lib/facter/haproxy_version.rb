# frozen_string_literal: true

# Fact: haproxy_version
#
# Purpose: get haproxy's current version
#
# Resolution:
#   Uses haproxy's -v flag and parses the result from 'version'
#
# Caveats:
#   none
#
# Notes:
#   None
# workaround Ubuntu 12.04: https://tickets.puppetlabs.com/browse/MODULES-2881
if defined?(Facter::Core::Execution.which) && Facter::Core::Execution.which('haproxy')
  Facter.add('haproxy_version') do
    haproxy_version_cmd = 'haproxy -v 2>&1'
    haproxy_version_result = Facter::Core::Execution.execute(haproxy_version_cmd)
    setcode do
      haproxy_version_result.to_s.lines.first.strip.split(%r{HA?.Proxy})[1].strip.split(%r{version})[1].strip.split(%r{((\d+\.){2,}\d+).*})[1]
    end
  end
end
