UNSUPPORTED_PLATFORMS = ['Suse', 'windows', 'AIX', 'Solaris'].freeze
MAX_RETRY_COUNT       = 12
RETRY_WAIT            = 10
ERROR_MATCHER         = %r{(no valid OpenPGP data found|keyserver timed out|keyserver receive failed)}

require 'singleton'

class LitmusHelper
  include Singleton
  include PuppetLitmus
end

# This method allows a block to be passed in and if an exception is raised
# that matches the 'error_matcher' matcher, the block will wait a set number
# of seconds before retrying.
# Params:
# - max_retry_count - Max number of retries
# - retry_wait_interval_secs - Number of seconds to wait before retry
# - error_matcher - Matcher which the exception raised must match to allow retry
# Example Usage:
# retry_on_error_matching(3, 5, /OpenGPG Error/) do
#   apply_manifest(pp, :catch_failures => true)
# end
def retry_on_error_matching(max_retry_count = MAX_RETRY_COUNT, retry_wait_interval_secs = RETRY_WAIT, error_matcher = ERROR_MATCHER)
  try = 0
  begin
    puts "retry_on_error_matching: try #{try}" unless try.zero?
    try += 1
    yield
  rescue StandardError => e
    raise unless try < max_retry_count && (error_matcher.nil? || e.message =~ error_matcher)
    sleep retry_wait_interval_secs
    retry
  end
end

RSpec.configure do |c|
  c.before :suite do
    # Make sure selinux is disabled so the tests work.
    LitmusHelper.instance.run_shell('setenforce 0', expect_failures: true) if os[:family] =~ %r{redhat|oracle}

    if os[:family] == 'redhat' && os[:release].to_i != 8
      LitmusHelper.instance.run_shell('puppet module install stahnma/epel')
      if os[:release][0] =~ %r{5|6}
        pp = <<-PP
        class { 'epel':

              epel_baseurl => "http://osmirror.delivery.puppetlabs.net/epel${::operatingsystemmajrelease}-\\$basearch/RPMS.all",
              epel_mirrorlist => "http://osmirror.delivery.puppetlabs.net/epel${::operatingsystemmajrelease}-\\$basearch/RPMS.all",

        }
        PP
        LitmusHelper.instance.apply_manifest(pp)
      else
        LitmusHelper.instance.run_shell("puppet apply -e 'include epel'")
      end
    end
    if os[:family] == 'redhat' && os[:release].to_i == 6
      LitmusHelper.instance.run_shell('yum clean all')
      LitmusHelper.instance.run_shell('yum --disablerepo="epel" update nss -y')
    end
    pp = <<-PP
    package { 'curl': ensure => present, }
    package { 'net-tools': ensure => present, }
    package { 'tmux': ensure => present, }
    package { 'socat': ensure => present, }
    PP
    LitmusHelper.instance.apply_manifest(pp)
    ['5556', '5557'].each do |port|
      LitmusHelper.instance.bolt_upload_file("spec/support/script-#{port}.sh", "/root/script-#{port}.sh")
      LitmusHelper.instance.run_shell(%(tmux new -d -s script-#{port}  "sh /root/script-#{port}.sh"), expect_failures: true)
      sleep 1
      LitmusHelper.instance.run_shell(%(netstat -tnl|grep ':#{port}'))
    end
  end
end
