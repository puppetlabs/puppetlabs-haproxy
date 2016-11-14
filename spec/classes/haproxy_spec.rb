require 'spec_helper'

describe 'haproxy', :type => :class do
  let(:default_facts) do
    {
      :concat_basedir => '/dne',
      :ipaddress      => '10.10.10.10'
    }
  end
  context 'on supported platforms' do
    describe 'for OS-agnostic configuration' do
      ['Debian', 'RedHat', 'Archlinux', 'FreeBSD', 'Gentoo',].each do |osfamily|
        context "on #{osfamily} family operatingsystems" do
          let(:facts) do
            { :osfamily => osfamily }.merge default_facts
          end
          let(:params) do
            {
              'service_ensure' => 'running',
              'package_ensure' => 'present',
              'service_manage' => true
            }
          end
          it 'should install the haproxy package' do
            subject.should contain_package('haproxy').with(
              'ensure' => 'present'
            )
          end
          it 'should install the haproxy service' do
            subject.should contain_service('haproxy').with(
              'ensure'     => 'running',
              'enable'     => 'true',
              'hasrestart' => 'true',
              'hasstatus'  => 'true'
            )
          end
        end
        # C9938
        context "on #{osfamily} when specifying custom content" do
          let(:facts) do
            { :osfamily => osfamily }.merge default_facts
          end
          let(:params) do
            { 'custom_fragment' => "listen stats :9090\n  mode http\n  stats uri /\n  stats auth puppet:puppet\n" }
          end
          it 'should set the haproxy package' do
            subject.should contain_concat__fragment('haproxy-haproxy-base').with_content(
              /listen stats :9090\n  mode http\n  stats uri \/\n  stats auth puppet:puppet\n/
            )
          end
        end
      end
    end

    describe 'for linux operating systems' do
      ['Debian', 'RedHat', 'Archlinux', 'Gentoo', ].each do |osfamily|
        context "on #{osfamily} family operatingsystems" do
          let(:facts) do
            { :osfamily => osfamily }.merge default_facts
          end
          it 'should set up /etc/haproxy/haproxy.cfg as a concat resource' do
            subject.should contain_concat('/etc/haproxy/haproxy.cfg').with(
              'owner' => '0',
              'group' => '0',
              'mode'  => '0644'
            )
          end
          it 'should manage the chroot directory' do
            subject.should contain_file('/var/lib/haproxy').with(
              'ensure' => 'directory',
              'owner'  => 'haproxy',
              'group'  => 'haproxy'
            )
          end
          it 'should contain a header concat fragment' do
            subject.should contain_concat__fragment('haproxy-00-header').with(
              'target'  => '/etc/haproxy/haproxy.cfg',
              'order'   => '01',
              'content' => "# This file managed by Puppet\n"
            )
          end
          it 'should contain a haproxy-haproxy-base concat fragment' do
            subject.should contain_concat__fragment('haproxy-haproxy-base').with(
              'target'  => '/etc/haproxy/haproxy.cfg',
              'order'   => '10'
            )
          end
          describe 'Base concat fragment contents' do
            let(:contents) { param_value(catalogue, 'concat::fragment', 'haproxy-haproxy-base', 'content').split("\n") }
            # C9936 C9937
            it 'should contain global and defaults sections' do
              contents.should include('global')
              contents.should include('defaults')
            end
            it 'should log to an ip address for local0' do
              contents.should be_any { |match| match =~ /  log  \d+(\.\d+){3} local0/ }
            end
            it 'should specify the default chroot' do
              contents.should include('  chroot  /var/lib/haproxy')
            end
            it 'should specify the correct user' do
              contents.should include('  user  haproxy')
            end
            it 'should specify the correct group' do
              contents.should include('  group  haproxy')
            end
            it 'should specify the correct pidfile' do
              contents.should include('  pidfile  /var/run/haproxy.pid')
            end
          end
        end
        context "on #{osfamily} family operatingsystems with setting haproxy.cfg location" do
          let(:facts) do
            { :osfamily => osfamily }.merge default_facts
          end
          let(:params) do
            {
              'config_file' => '/tmp/haproxy.cfg',
            }
          end
          it 'should set up /tmp/haproxy.cfg as a concat resource' do
            subject.should contain_concat('/tmp/haproxy.cfg').with(
              'owner' => '0',
              'group' => '0',
              'mode'  => '0644'
            )
          end
        end
        context "on #{osfamily} family operatingsystems without managing the service" do
          let(:facts) do
            { :osfamily => osfamily }.merge default_facts
          end
          let(:params) do
            {
              'service_ensure' => true,
              'package_ensure' => 'present',
              'service_manage' => false
            }
          end
          it 'should install the haproxy package' do
            subject.should contain_package('haproxy').with(
              'ensure' => 'present'
            )
          end
          it 'should not manage the haproxy service' do
            subject.should_not contain_service('haproxy')
          end
          it 'should set up /etc/haproxy/haproxy.cfg as a concat resource' do
            subject.should contain_concat('/etc/haproxy/haproxy.cfg').with(
              'owner' => '0',
              'group' => '0',
              'mode'  => '0644'
            )
          end
          it 'should manage the chroot directory' do
            subject.should contain_file('/var/lib/haproxy').with(
              'ensure' => 'directory'
            )
          end
          it 'should contain a header concat fragment' do
            subject.should contain_concat__fragment('haproxy-00-header').with(
              'target'  => '/etc/haproxy/haproxy.cfg',
              'order'   => '01',
              'content' => "# This file managed by Puppet\n"
            )
          end
          it 'should contain a haproxy-base concat fragment' do
            subject.should contain_concat__fragment('haproxy-haproxy-base').with(
              'target'  => '/etc/haproxy/haproxy.cfg',
              'order'   => '10'
            )
          end
          describe 'Base concat fragment contents' do
            let(:contents) { param_value(catalogue, 'concat::fragment', 'haproxy-haproxy-base', 'content').split("\n") }
            it 'should contain global and defaults sections' do
              contents.should include('global')
              contents.should include('defaults')
            end
            it 'should log to an ip address for local0' do
              contents.should be_any { |match| match =~ /  log  \d+(\.\d+){3} local0/ }
            end
            it 'should specify the default chroot' do
              contents.should include('  chroot  /var/lib/haproxy')
            end
            it 'should specify the correct user' do
              contents.should include('  user  haproxy')
            end
            it 'should specify the correct group' do
              contents.should include('  group  haproxy')
            end
            it 'should specify the correct pidfile' do
              contents.should include('  pidfile  /var/run/haproxy.pid')
            end
          end
        end
        context "on #{osfamily} when specifying a restart_command" do
          let(:facts) do
            { :osfamily => osfamily }.merge default_facts
          end
          let(:params) do
            {
              'restart_command' => '/etc/init.d/haproxy reload',
              'service_manage'  => true
            }
          end
          it 'should set the haproxy package' do
            subject.should contain_service('haproxy').with(
              'restart' => '/etc/init.d/haproxy reload'
            )
          end
        end
      end
    end

    describe 'for freebsd' do
      context "on freebsd family operatingsystems" do
        let(:facts) do
          { :osfamily => 'FreeBSD' }.merge default_facts
        end
        it 'should set up /usr/local/etc/haproxy.conf as a concat resource' do
          subject.should contain_concat('/usr/local/etc/haproxy.conf').with(
            'owner' => '0',
            'group' => '0',
            'mode'  => '0644'
          )
        end
        it 'should manage the chroot directory' do
          subject.should contain_file('/usr/local/haproxy').with(
            'ensure' => 'directory'
          )
        end
        it 'should contain a header concat fragment' do
          subject.should contain_concat__fragment('haproxy-00-header').with(
            'target'  => '/usr/local/etc/haproxy.conf',
            'order'   => '01',
            'content' => "# This file managed by Puppet\n"
          )
        end
        it 'should contain a haproxy-base concat fragment' do
          subject.should contain_concat__fragment('haproxy-haproxy-base').with(
            'target'  => '/usr/local/etc/haproxy.conf',
            'order'   => '10'
          )
        end
        describe 'Base concat fragment contents' do
          let(:contents) { param_value(catalogue, 'concat::fragment', 'haproxy-haproxy-base', 'content').split("\n") }
          # C9936 C9937
          it 'should contain global and defaults sections' do
            contents.should include('global')
            contents.should include('defaults')
          end
          it 'should log to an ip address for local0' do
            contents.should be_any { |match| match =~ /  log  \d+(\.\d+){3} local0/ }
          end
          it 'should specify the default chroot' do
            contents.should include('  chroot  /usr/local/haproxy')
          end
          it 'should specify the correct pidfile' do
            contents.should include('  pidfile  /var/run/haproxy.pid')
          end
        end
      end
      context "on freebsd family operatingsystems without managing the service" do
        let(:facts) do
          { :osfamily => 'FreeBSD' }.merge default_facts
        end
        let(:params) do
          {
            'service_ensure' => true,
            'package_ensure' => 'present',
            'service_manage' => false
          }
        end
        it 'should install the haproxy package' do
          subject.should contain_package('haproxy').with(
            'ensure' => 'present'
          )
        end
        it 'should not manage the haproxy service' do
          subject.should_not contain_service('haproxy')
        end
        it 'should set up /usr/local/etc/haproxy.conf as a concat resource' do
          subject.should contain_concat('/usr/local/etc/haproxy.conf').with(
            'owner' => '0',
            'group' => '0',
            'mode'  => '0644'
          )
        end
        it 'should manage the chroot directory' do
          subject.should contain_file('/usr/local/haproxy').with(
            'ensure' => 'directory'
          )
        end
        it 'should contain a header concat fragment' do
          subject.should contain_concat__fragment('haproxy-00-header').with(
            'target'  => '/usr/local/etc/haproxy.conf',
            'order'   => '01',
            'content' => "# This file managed by Puppet\n"
          )
        end
        it 'should contain a haproxy-base concat fragment' do
          subject.should contain_concat__fragment('haproxy-haproxy-base').with(
            'target'  => '/usr/local/etc/haproxy.conf',
            'order'   => '10'
          )
        end
        describe 'Base concat fragment contents' do
          let(:contents) { param_value(catalogue, 'concat::fragment', 'haproxy-haproxy-base', 'content').split("\n") }
          it 'should contain global and defaults sections' do
            contents.should include('global')
            contents.should include('defaults')
          end
          it 'should log to an ip address for local0' do
            contents.should be_any { |match| match =~ /  log  \d+(\.\d+){3} local0/ }
          end
          it 'should specify the default chroot' do
            contents.should include('  chroot  /usr/local/haproxy')
          end
          it 'should specify the correct pidfile' do
            contents.should include('  pidfile  /var/run/haproxy.pid')
          end
        end
      end
      context "on freebsd when specifying a restart_command" do
        let(:facts) do
          { :osfamily => 'FreeBSD' }.merge default_facts
        end
        let(:params) do
          {
            'restart_command' => '/usr/local/etc/rc.d/haproxy reload',
            'service_manage'  => true
          }
        end
        it 'should set the haproxy package' do
          subject.should contain_service('haproxy').with(
            'restart' => '/usr/local/etc/rc.d/haproxy reload'
          )
        end
      end
    end

    describe 'for OS-specific configuration' do
      context 'only on Debian family operatingsystems' do
        let(:facts) do
          { :osfamily => 'Debian' }.merge default_facts
        end
        it 'should manage haproxy service defaults' do
          subject.should contain_file('/etc/default/haproxy')
          verify_contents(catalogue, '/etc/default/haproxy', ['ENABLED=1'])
        end
      end
      context 'only on RedHat family operatingsystems' do
        let(:facts) do
          { :osfamily => 'RedHat' }.merge default_facts
        end
      end
      context 'only on Gentoo family operatingsystems' do
        let(:facts) do
          { :osfamily => 'Gentoo' }.merge default_facts
        end
        it 'should create directory /etc/haproxy' do
          subject.should contain_file('/etc/haproxy').with(
            'ensure' => 'directory'
          )
        end
      end
    end

    describe 'when merging global and defaults options with user-supplied overrides and additions' do
      # For testing the merging functionality we restrict ourselves to
      # Debian OS family so that we don't have to juggle different sets of
      # global_options and defaults_options (like for FreeBSD).
      ['Debian' ].each do |osfamily|
        context "on #{osfamily} family operatingsystems" do
          let(:facts) do
            { :osfamily => osfamily }.merge default_facts
          end
          let(:contents) { param_value(catalogue, 'concat::fragment', 'haproxy-haproxy-base', 'content').split("\n") }
          let(:params) do
            {
              'merge_options'   => true,
              'global_options'  => {
                'log-send-hostname' => '',
                'chroot'            => '/srv/haproxy-chroot',
                'maxconn'           => nil,
                'stats'             => [
                  'socket /var/lib/haproxy/admin.sock mode 660 level admin',
                  'timeout 30s'
                ]
              },
              'defaults_options' => {
                'mode'    => 'http',
                'option'  => [
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
              },
            }
          end
          it 'should manage a custom chroot directory' do
            subject.should contain_file('/srv/haproxy-chroot').with(
              'ensure' => 'directory',
              'owner'  => 'haproxy',
              'group'  => 'haproxy'
            )
          end
          it 'should contain global and defaults sections' do
            contents.should include('global')
            contents.should include('defaults')
          end
          it 'should send hostname with log in global options' do
            contents.should include('  log-send-hostname  ')
          end
          it 'should enable admin stats and stats timeout in global options' do
            contents.should include('  stats  socket /var/lib/haproxy/admin.sock mode 660 level admin')
            contents.should include('  stats  timeout 30s')
          end
          it 'should log to an ip address for local0' do
            contents.should be_any { |match| match =~ /  log  \d+(\.\d+){3} local0/ }
          end
          it 'should specify the correct user' do
            contents.should include('  user  haproxy')
          end
          it 'should specify the correct group' do
            contents.should include('  group  haproxy')
          end
          it 'should specify the correct pidfile' do
            contents.should include('  pidfile  /var/run/haproxy.pid')
          end
          it 'should set mode http in default options' do
            contents.should include('  mode  http')
          end
          it 'should not set the global parameter "maxconn"' do
            contents.should_not include('  maxconn  4000')
          end
          it 'should set various options in defaults, removing the "redispatch" option' do
            contents.should_not include('  option  redispatch')
            contents.should     include('  option  abortonclose')
            contents.should     include('  option  logasap')
            contents.should     include('  option  dontlognull')
            contents.should     include('  option  httplog')
            contents.should     include('  option  http-server-close')
            contents.should     include('  option  forwardfor except 127.0.0.1')
          end
          it 'should set timeouts in defaults, removing the "http-request 10s" and "queue 1m" timeout' do
            contents.should_not include('  timeout  http-request 10s')
            contents.should_not include('  timeout  queue 1m')
            contents.should     include('  timeout  connect 5s')
            contents.should     include('  timeout  check 7s')
            contents.should     include('  timeout  client 1m')
            contents.should     include('  timeout  server 1m')
          end
        end
      end
    end

    describe 'when overriding global and defaults options with user-supplied overrides and additions' do
      # For testing the merging functionality we restrict ourselves to
      # Debian OS family so that we don't have to juggle different sets of
      # global_options and defaults_options (like for FreeBSD).
      ['Debian' ].each do |osfamily|
        context "on #{osfamily} family operatingsystems" do
          let(:facts) do
            { :osfamily => osfamily }.merge default_facts
          end
          let(:contents) { param_value(catalogue, 'concat::fragment', 'haproxy-haproxy-base', 'content').split("\n") }
          let(:params) do
            {
              'merge_options'   => false,
              'global_options'  => {
                'log-send-hostname' => '',
                'chroot'            => '/srv/haproxy-chroot',
                'stats'             => [
                  'socket /var/lib/haproxy/admin.sock mode 660 level admin',
                  'timeout 30s'
                ]
              },
              'defaults_options' => {
                'mode'    => 'http',
                'option'  => [
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
              },
            }
          end
          it 'should manage a custom chroot directory' do
            subject.should contain_file('/srv/haproxy-chroot').with(
              'ensure' => 'directory'
            )
          end
          it 'should contain global and defaults sections' do
            contents.should include('global')
            contents.should include('defaults')
          end
          it 'should send hostname with log in global options' do
            contents.should include('  log-send-hostname  ')
          end
          it 'should enable admin stats and stats timeout in global options' do
            contents.should include('  stats  socket /var/lib/haproxy/admin.sock mode 660 level admin')
            contents.should include('  stats  timeout 30s')
          end
          it 'should set mode http in default options' do
            contents.should include('  mode  http')
          end
          it 'should not set the global parameter "maxconn"' do
            contents.should_not include('  maxconn  4000')
          end
          it 'should set various options in defaults, removing the "redispatch" option' do
            contents.should_not include('  option  redispatch')
            contents.should     include('  option  abortonclose')
            contents.should     include('  option  logasap')
            contents.should     include('  option  dontlognull')
            contents.should     include('  option  httplog')
            contents.should     include('  option  http-server-close')
            contents.should     include('  option  forwardfor except 127.0.0.1')
          end
          it 'should set timeouts in defaults, removing the "http-request 10s" and "queue 1m" timeout' do
            contents.should_not include('  timeout  http-request 10s')
            contents.should_not include('  timeout  queue 1m')
            contents.should     include('  timeout  connect 5s')
            contents.should     include('  timeout  check 7s')
            contents.should     include('  timeout  client 1m')
            contents.should     include('  timeout  server 1m')
          end
        end
      end
    end

    describe 'when specifying global_options with arrays instead of hashes' do
      # For testing input validation we restrict ourselves to
      # Debian OS family so that we don't have to juggle different sets of
      # global_options and defaults_options (like for FreeBSD).
      ['Debian' ].each do |osfamily|
        context "on #{osfamily} family operatingsystems" do
          let(:facts) do
            { :osfamily => osfamily }.merge default_facts
          end
          let(:contents) { param_value(catalogue, 'concat::fragment', 'haproxy-haproxy-base', 'content').split("\n") }
          let(:params) do
            {
              'merge_options'   => true,
              'global_options'  => [ 'log-send-hostname', 'chroot /srv/haproxy-chroot' ]
            }
          end
          it 'should raise error' do
            expect { catalogue }.to raise_error Puppet::Error, /is not a Hash/
          end
        end
      end
    end
    describe 'when specifying defaults_options with arrays instead of hashes' do
      # For testing input validation we restrict ourselves to
      # Debian OS family so that we don't have to juggle different sets of
      # global_options and defaults_options (like for FreeBSD).
      ['Debian' ].each do |osfamily|
        context "on #{osfamily} family operatingsystems" do
          let(:facts) do
            { :osfamily => osfamily }.merge default_facts
          end
          let(:contents) { param_value(catalogue, 'concat::fragment', 'haproxy-haproxy-base', 'content').split("\n") }
          let(:params) do
            {
              'merge_options'   => true,
              'defaults_options' => [
                'mode http',
                'timeout connect 5s',
                'timeout client 1m'
              ]
            }
          end
          it 'should raise error' do
            expect { catalogue }.to raise_error Puppet::Error, /is not a Hash/
          end
        end
      end
    end
  end

  context 'on unsupported operatingsystems' do
    let(:facts) do
      { :osfamily => 'windows' }.merge default_facts
    end
    it do
      expect {
        should contain_service('haproxy')
      }.to raise_error(Puppet::Error, /operating system is not supported with the haproxy module/)
    end
  end


end
