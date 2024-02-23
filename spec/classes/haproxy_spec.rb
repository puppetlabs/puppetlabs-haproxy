# frozen_string_literal: true

require 'spec_helper'

describe 'haproxy', type: :class do
  let(:default_facts) do
    {
      concat_basedir: '/dne',
      networking: {
        ip: '10.10.10.10'
      }
    }
  end

  describe 'for OS-agnostic configuration' do
    ['Debian', 'RedHat', 'Archlinux', 'FreeBSD', 'Gentoo'].each do |osfamily|
      context "when on #{osfamily} family operatingsystems" do
        let(:facts) do
          { os: { family: osfamily } }.merge default_facts
        end
        let(:params) do
          {
            'service_ensure' => 'running',
            'package_ensure' => 'present',
            'service_manage' => true
          }
        end

        it 'installs the haproxy package' do
          subject.should contain_package('haproxy').with(
            'ensure' => 'present',
          )
        end

        it 'installs the haproxy service' do
          subject.should contain_service('haproxy').with(
            'ensure' => 'running', 'enable' => 'true',
            'hasrestart' => 'true', 'hasstatus' => 'true'
          )
        end
      end

      context "when on #{osfamily} specifying a package version" do
        let(:facts) do
          { os: { family: osfamily } }.merge default_facts
        end
        let(:params) do
          {
            'service_ensure' => 'running',
            'package_ensure' => '1.7.9-1',
            'service_manage' => true
          }
        end

        it 'installs the haproxy package in a specific version' do
          subject.should contain_package('haproxy').with(
            'ensure' => '1.7.9-1',
          )
        end

        it 'installs the haproxy service' do
          subject.should contain_service('haproxy').with(
            'ensure' => 'running', 'enable' => 'true',
            'hasrestart' => 'true', 'hasstatus' => 'true'
          )
        end
      end

      # C9938
      context "when on #{osfamily} when specifying custom content" do
        let(:facts) do
          { os: { family: osfamily } }.merge default_facts
        end
        let(:params) do
          { 'custom_fragment' => "listen stats :9090\n  mode http\n  stats uri /\n  stats auth puppet:puppet\n" }
        end

        it 'sets the haproxy package' do
          subject.should contain_concat__fragment('haproxy-haproxy-base').with_content(
            %r{listen stats :9090\n  mode http\n  stats uri /\n  stats auth puppet:puppet\n},
          )
        end
      end
    end
  end

  describe 'for linux operating systems' do
    ['Debian', 'RedHat', 'Archlinux', 'Gentoo'].each do |osfamily|
      context "when on #{osfamily} family operatingsystems" do
        let(:facts) do
          { os: { family: osfamily } }.merge default_facts
        end

        it 'sets up /etc/haproxy/haproxy.cfg as a concat resource' do
          subject.should contain_concat('/etc/haproxy/haproxy.cfg').with(
            'owner' => '0',
            'group' => '0',
            'mode' => '0640',
          )
        end

        it 'manages the chroot directory' do
          subject.should contain_file('/var/lib/haproxy').with(
            'ensure' => 'directory',
            'owner' => 'haproxy',
            'group' => 'haproxy',
          )
        end

        it 'contains a header concat fragment' do
          subject.should contain_concat__fragment('haproxy-00-header').with(
            'target' => '/etc/haproxy/haproxy.cfg',
            'order' => '01',
            'content' => "# This file is managed by Puppet\n",
          )
        end

        it 'contains a haproxy-haproxy-base concat fragment' do
          subject.should contain_concat__fragment('haproxy-haproxy-base').with(
            'target' => '/etc/haproxy/haproxy.cfg',
            'order' => '10',
          )
        end

        describe 'Base concat fragment contents' do
          let(:contents) { param_value(catalogue, 'concat::fragment', 'haproxy-haproxy-base', 'content').split("\n") }

          # C9936 C9937
          it 'contains global and defaults sections' do
            contents.should include('global')
            contents.should include('defaults')
          end

          it 'logs to an ip address for local0' do
            contents.should be_any do |match|
              match =~ %r{  log  \d+(\.\d+){3} local0}
            end
          end

          it 'specifies the default chroot' do
            contents.should include('  chroot  /var/lib/haproxy')
          end

          it 'specifies the correct user' do
            contents.should include('  user  haproxy')
          end

          it 'specifies the correct group' do
            contents.should include('  group  haproxy')
          end

          it 'specifies the correct pidfile' do
            contents.should include('  pidfile  /var/run/haproxy.pid')
          end
        end
      end

      context "when on #{osfamily} family operatingsystems with setting haproxy.cfg location" do
        let(:facts) do
          { os: { family: osfamily } }.merge default_facts
        end
        let(:params) do
          {
            'config_file' => '/tmp/haproxy.cfg'
          }
        end

        it 'sets up /tmp/haproxy.cfg as a concat resource' do
          subject.should contain_concat('/tmp/haproxy.cfg').with(
            'owner' => '0',
            'group' => '0',
            'mode' => '0640',
          )
        end
      end

      context "when on #{osfamily} family operatingsystems without managing the service" do
        let(:facts) do
          { os: { family: osfamily } }.merge default_facts
        end
        let(:params) do
          {
            'service_ensure' => true,
            'package_ensure' => 'present',
            'service_manage' => false
          }
        end

        it 'installs the haproxy package' do
          subject.should contain_package('haproxy').with(
            'ensure' => 'present',
          )
        end

        it 'does not manage the haproxy service' do
          subject.should_not contain_service('haproxy')
        end

        it 'sets up /etc/haproxy/haproxy.cfg as a concat resource' do
          subject.should contain_concat('/etc/haproxy/haproxy.cfg').with(
            'owner' => '0',
            'group' => '0',
            'mode' => '0640',
          )
        end

        it 'manages the chroot directory' do
          subject.should contain_file('/var/lib/haproxy').with(
            'ensure' => 'directory',
          )
        end

        it 'contains a header concat fragment' do
          subject.should contain_concat__fragment('haproxy-00-header').with(
            'target' => '/etc/haproxy/haproxy.cfg',
            'order' => '01',
            'content' => "# This file is managed by Puppet\n",
          )
        end

        it 'contains a haproxy-base concat fragment' do
          subject.should contain_concat__fragment('haproxy-haproxy-base').with(
            'target' => '/etc/haproxy/haproxy.cfg',
            'order' => '10',
          )
        end

        describe 'Base concat fragment contents' do
          let(:contents) { param_value(catalogue, 'concat::fragment', 'haproxy-haproxy-base', 'content').split("\n") }

          it 'contains global and defaults sections' do
            contents.should include('global')
            contents.should include('defaults')
          end

          it 'logs to an ip address for local0' do
            contents.should be_any do |match|
              match =~ %r{  log  \d+(\.\d+){3} local0}
            end
          end

          it 'specifies the default chroot' do
            contents.should include('  chroot  /var/lib/haproxy')
          end

          it 'specifies the correct user' do
            contents.should include('  user  haproxy')
          end

          it 'specifies the correct group' do
            contents.should include('  group  haproxy')
          end

          it 'specifies the correct pidfile' do
            contents.should include('  pidfile  /var/run/haproxy.pid')
          end
        end
      end

      context "when on #{osfamily} when specifying a restart_command" do
        let(:facts) do
          { os: { family: osfamily } }.merge default_facts
        end
        let(:params) do
          {
            'restart_command' => '/etc/init.d/haproxy reload',
            'service_manage' => true
          }
        end

        it 'sets the haproxy package' do
          subject.should contain_service('haproxy').with(
            'restart' => '/etc/init.d/haproxy reload',
          )
        end
      end
    end
  end

  describe 'for freebsd' do
    context 'when on freebsd family operatingsystems' do
      let(:facts) do
        { os: { family: 'FreeBSD' } }.merge default_facts
      end

      it 'sets up /usr/local/etc/haproxy.conf as a concat resource' do
        subject.should contain_concat('/usr/local/etc/haproxy.conf').with(
          'owner' => '0',
          'group' => '0',
          'mode' => '0640',
        )
      end

      it 'manages the chroot directory' do
        subject.should contain_file('/usr/local/haproxy').with(
          'ensure' => 'directory',
        )
      end

      it 'contains a header concat fragment' do
        subject.should contain_concat__fragment('haproxy-00-header').with(
          'target' => '/usr/local/etc/haproxy.conf',
          'order' => '01',
          'content' => "# This file is managed by Puppet\n",
        )
      end

      it 'contains a haproxy-base concat fragment' do
        subject.should contain_concat__fragment('haproxy-haproxy-base').with(
          'target' => '/usr/local/etc/haproxy.conf',
          'order' => '10',
        )
      end

      describe 'Base concat fragment contents' do
        let(:contents) { param_value(catalogue, 'concat::fragment', 'haproxy-haproxy-base', 'content').split("\n") }

        # C9936 C9937
        it 'contains global and defaults sections' do
          contents.should include('global')
          contents.should include('defaults')
        end

        it 'logs to an ip address for local0' do
          contents.should be_any do |match|
            match =~ %r{  log  \d+(\.\d+){3} local0}
          end
        end

        it 'specifies the default chroot' do
          contents.should include('  chroot  /usr/local/haproxy')
        end

        it 'specifies the correct pidfile' do
          contents.should include('  pidfile  /var/run/haproxy.pid')
        end
      end
    end

    context 'when on freebsd family operatingsystems without managing the service' do
      let(:facts) do
        { os: { family: 'FreeBSD' } }.merge default_facts
      end
      let(:params) do
        {
          'service_ensure' => true,
          'package_ensure' => 'present',
          'service_manage' => false
        }
      end

      it 'installs the haproxy package' do
        subject.should contain_package('haproxy').with(
          'ensure' => 'present',
        )
      end

      it 'does not manage the haproxy service' do
        subject.should_not contain_service('haproxy')
      end

      it 'sets up /usr/local/etc/haproxy.conf as a concat resource' do
        subject.should contain_concat('/usr/local/etc/haproxy.conf').with(
          'owner' => '0',
          'group' => '0',
          'mode' => '0640',
        )
      end

      it 'manages the chroot directory' do
        subject.should contain_file('/usr/local/haproxy').with(
          'ensure' => 'directory',
        )
      end

      it 'contains a header concat fragment' do
        subject.should contain_concat__fragment('haproxy-00-header').with(
          'target' => '/usr/local/etc/haproxy.conf',
          'order' => '01',
          'content' => "# This file is managed by Puppet\n",
        )
      end

      it 'contains a haproxy-base concat fragment' do
        subject.should contain_concat__fragment('haproxy-haproxy-base').with(
          'target' => '/usr/local/etc/haproxy.conf',
          'order' => '10',
        )
      end

      describe 'Base concat fragment contents' do
        let(:contents) { param_value(catalogue, 'concat::fragment', 'haproxy-haproxy-base', 'content').split("\n") }

        it 'contains global and defaults sections' do
          contents.should include('global')
          contents.should include('defaults')
        end

        it 'logs to an ip address for local0' do
          contents.should be_any do |match|
            match =~ %r{  log  \d+(\.\d+){3} local0}
          end
        end

        it 'specifies the default chroot' do
          contents.should include('  chroot  /usr/local/haproxy')
        end

        it 'specifies the correct pidfile' do
          contents.should include('  pidfile  /var/run/haproxy.pid')
        end
      end
    end

    context 'when on freebsd when specifying a restart_command' do
      let(:facts) do
        { os: { family: 'FreeBSD' } }.merge default_facts
      end
      let(:params) do
        {
          'restart_command' => '/usr/local/etc/rc.d/haproxy reload',
          'service_manage' => true
        }
      end

      it 'sets the haproxy package' do
        subject.should contain_service('haproxy').with(
          'restart' => '/usr/local/etc/rc.d/haproxy reload',
        )
      end
    end
  end

  describe 'for OS-specific configuration' do
    context 'when only on Debian family operatingsystems' do
      let(:facts) do
        { os: { family: 'Debian' } }.merge default_facts
      end

      it 'manages haproxy service defaults' do
        subject.should contain_file('/etc/default/haproxy')
        verify_contents(catalogue, '/etc/default/haproxy', ['ENABLED=1'])
      end
    end

    context 'when only on Gentoo family operatingsystems' do
      let(:facts) do
        { os: { family: 'Gentoo' } }.merge default_facts
      end

      it 'creates directory /etc/haproxy' do
        subject.should contain_file('/etc/haproxy').with(
          'ensure' => 'directory',
        )
      end
    end
  end

  describe 'when merging global and defaults options with user-supplied overrides and additions' do
    # For testing the merging functionality we restrict ourselves to
    # Debian OS family so that we don't have to juggle different sets of
    # global_options and defaults_options (like for FreeBSD).
    ['Debian'].each do |osfamily|
      context "when on #{osfamily} family operatingsystems" do
        let(:facts) do
          { os: { family: osfamily } }.merge default_facts
        end
        let(:contents) { param_value(catalogue, 'concat::fragment', 'haproxy-haproxy-base', 'content').split("\n") }
        let(:params) do
          {
            'merge_options' => true,
            'global_options' => {
              'log-send-hostname' => '',
              'chroot' => '/srv/haproxy-chroot',
              'maxconn' => nil,
              'stats' => [
                'socket /var/lib/haproxy/admin.sock mode 660 level admin',
                'timeout 30s',
              ]
            },
            'defaults_options' => {
              'mode' => 'http',
              'option' => [
                'abortonclose',
                'logasap',
                'dontlognull',
                'httplog',
                'http-server-close',
                'forwardfor except 127.0.0.1',
              ],
              'timeout' => [
                'connect 5s',
                'client 1m',
                'server 1m',
                'check 7s',
              ]
            }
          }
        end

        it 'manages a custom chroot directory' do
          subject.should contain_file('/srv/haproxy-chroot').with(
            'ensure' => 'directory',
            'owner' => 'haproxy',
            'group' => 'haproxy',
          )
        end

        it 'contains global and defaults sections' do
          contents.should include('global')
          contents.should include('defaults')
        end

        it 'sends hostname with log in global options' do
          contents.should include('  log-send-hostname  ')
        end

        it 'enables admin stats and stats timeout in global options' do
          contents.should include('  stats  socket /var/lib/haproxy/admin.sock mode 660 level admin')
          contents.should include('  stats  timeout 30s')
        end

        it 'logs to an ip address for local0' do
          contents.should be_any do |match|
            match =~ %r{  log  \d+(\.\d+){3} local0}
          end
        end

        it 'specifies the correct user' do
          contents.should include('  user  haproxy')
        end

        it 'specifies the correct group' do
          contents.should include('  group  haproxy')
        end

        it 'specifies the correct pidfile' do
          contents.should include('  pidfile  /var/run/haproxy.pid')
        end

        it 'sets mode http in default options' do
          contents.should include('  mode  http')
        end

        it 'does not set the global parameter "maxconn"' do
          contents.should_not include('  maxconn  4000')
        end

        expected_array_one = ['  option  abortonclose', '  option  logasap', '  option  dontlognull',
                              '  option  httplog', '  option  http-server-close', '  option  forwardfor except 127.0.0.1']
        it 'sets various options in defaults, removing the "redispatch" option' do
          contents.should_not include('  option  redispatch')
          expected_array_one.each do |expected|
            contents.should include(expected)
          end
        end

        expected_array_two = ['  timeout  connect 5s', '  timeout  check 7s', '  timeout  client 1m', '  timeout  server 1m']
        it 'sets timeouts in defaults, removing the "http-request 10s" and "queue 1m" timeout' do
          contents.should_not include('  timeout  http-request 10s')
          contents.should_not include('  timeout  queue 1m')
          expected_array_two.each do |expected|
            contents.should include(expected)
          end
        end
      end
    end
  end

  describe 'when overriding global and defaults options with user-supplied overrides and additions' do
    # For testing the merging functionality we restrict ourselves to
    # Debian OS family so that we don't have to juggle different sets of
    # global_options and defaults_options (like for FreeBSD).
    ['Debian'].each do |osfamily|
      context "when on #{osfamily} family operatingsystems" do
        let(:facts) do
          { os: { family: osfamily } }.merge default_facts
        end
        let(:contents) { param_value(catalogue, 'concat::fragment', 'haproxy-haproxy-base', 'content').split("\n") }
        let(:params) do
          {
            'merge_options' => false,
            'global_options' => {
              'log-send-hostname' => '',
              'chroot' => '/srv/haproxy-chroot',
              'stats' => [
                'socket /var/lib/haproxy/admin.sock mode 660 level admin',
                'timeout 30s',
              ]
            },
            'defaults_options' => {
              'mode' => 'http',
              'option' => [
                'abortonclose',
                'logasap',
                'dontlognull',
                'httplog',
                'http-server-close',
                'forwardfor except 127.0.0.1',
              ],
              'timeout' => [
                'connect 5s',
                'client 1m',
                'server 1m',
                'check 7s',
              ]
            }
          }
        end

        it 'manages a custom chroot directory' do
          subject.should contain_file('/srv/haproxy-chroot').with(
            'ensure' => 'directory',
          )
        end

        it 'contains global and defaults sections' do
          contents.should include('global')
          contents.should include('defaults')
        end

        it 'sends hostname with log in global options' do
          contents.should include('  log-send-hostname  ')
        end

        it 'enables admin stats and stats timeout in global options' do
          contents.should include('  stats  socket /var/lib/haproxy/admin.sock mode 660 level admin')
          contents.should include('  stats  timeout 30s')
        end

        it 'sets mode http in default options' do
          contents.should include('  mode  http')
        end

        it 'does not set the global parameter "maxconn"' do
          contents.should_not include('  maxconn  4000')
        end

        expected_array_one = ['  option  abortonclose', '  option  logasap', '  option  dontlognull', '  option  httplog',
                              '  option  http-server-close', '  option  forwardfor except 127.0.0.1']
        it 'sets various options in defaults, removing the "redispatch" option' do
          contents.should_not include('  option  redispatch')
          expected_array_one.each do |expected|
            contents.should include(expected)
          end
        end

        expected_array_two = ['  timeout  connect 5s', '  timeout  check 7s', '  timeout  client 1m', '  timeout  server 1m']
        it 'sets timeouts in defaults, removing the "http-request 10s" and "queue 1m" timeout' do
          contents.should_not include('  timeout  http-request 10s')
          contents.should_not include('  timeout  queue 1m')
          expected_array_two.each do |expected|
            contents.should include(expected)
          end
        end
      end
    end
  end

  context 'when install_options are specified' do
    let(:facts) do
      { os: { family: 'Debian' } }.merge default_facts
    end

    let(:params) do
      {
        'install_options' => ['--no-install-recommends'],
      }
    end

    it 'installs the haproxy package' do
      subject.should contain_package('haproxy').with(
        'ensure'          => 'present',
        'install_options' => ['--no-install-recommends'],
      )
    end
  end

  context 'when on unsupported operatingsystems' do
    let(:facts) do
      { os: { family: 'windows' } }.merge default_facts
    end

    it do
      expect {
        is_expected.to contain_service('haproxy')
      }.to raise_error(Puppet::Error, %r{operating system is not supported with the haproxy module})
    end
  end
end
