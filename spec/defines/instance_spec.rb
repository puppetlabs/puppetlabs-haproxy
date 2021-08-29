# frozen_string_literal: true

require 'spec_helper'

describe 'haproxy::instance' do
  let(:default_facts) do
    {
      concat_basedir: '/dne',
      ipaddress: '10.10.10.10',
    }
  end

  let(:pre_condition) do
    'include haproxy::params'
  end

  # haproxy::instance with service name "haproxy".

  context 'when on supported platforms' do
    let(:title) { 'haproxy' }

    describe 'for OS-agnostic configuration' do
      ['Debian', 'RedHat', 'Archlinux', 'FreeBSD'].each do |osfamily|
        context "on #{osfamily} family operatingsystems" do
          let(:facts) do
            { osfamily: osfamily }.merge default_facts
          end
          let(:params) do
            {
              'service_ensure' => 'running',
              'package_ensure' => 'present',
              'package_name'   => 'haproxy',
              'service_manage' => true,
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
        context "on #{osfamily} family specifying a package version" do
          let(:facts) do
            { osfamily: osfamily }.merge default_facts
          end
          let(:params) do
            {
              'service_ensure' => 'running',
              'package_ensure' => '1.7.9-1',
              'package_name'   => 'haproxy',
              'service_manage' => true,
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
        context "on #{osfamily} when specifying custom content" do
          let(:facts) do
            { osfamily: osfamily }.merge default_facts
          end
          let(:params) do
            { 'custom_fragment' => "listen stats :9090\n  mode http\n  stats uri /\n  stats auth puppet:puppet\n" }
          end

          it 'sets the haproxy package' do
            subject.should contain_concat__fragment('haproxy-haproxy-base').with_content(
              %r{listen stats :9090\n  mode http\n  stats uri \/\n  stats auth puppet:puppet\n},
            )
          end
        end
      end
    end

    describe 'for linux operating systems' do
      ['Debian', 'RedHat', 'Archlinux'].each do |osfamily|
        context "on #{osfamily} family operatingsystems" do
          let(:facts) do
            { osfamily: osfamily }.merge default_facts
          end

          it 'sets up /etc/haproxy/haproxy.cfg as a concat resource' do
            subject.should contain_concat('/etc/haproxy/haproxy.cfg').with(
              'owner' => '0',
              'group' => '0',
              'mode'  => '0640',
            )
          end
          it 'manages the chroot directory' do
            subject.should contain_file('/var/lib/haproxy').with(
              'ensure' => 'directory',
              'owner'  => 'haproxy',
              'group'  => 'haproxy',
            )
          end
          it 'contains a header concat fragment' do
            subject.should contain_concat__fragment('haproxy-00-header').with(
              'target'  => '/etc/haproxy/haproxy.cfg',
              'order'   => '01',
              'content' => "# This file is managed by Puppet\n",
            )
          end
          it 'contains a haproxy-haproxy-base concat fragment' do
            subject.should contain_concat__fragment('haproxy-haproxy-base').with(
              'target'  => '/etc/haproxy/haproxy.cfg',
              'order'   => '10',
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
        context "when on #{osfamily} family operatingsystems without managing the service" do
          let(:facts) do
            { osfamily: osfamily }.merge default_facts
          end
          let(:params) do
            {
              'service_ensure' => true,
              'package_ensure' => 'present',
              'package_name'   => 'haproxy',
              'service_manage' => false,
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
              'mode'  => '0640',
            )
          end
          it 'manages the chroot directory' do
            subject.should contain_file('/var/lib/haproxy').with(
              'ensure' => 'directory',
            )
          end
          it 'contains a header concat fragment' do
            subject.should contain_concat__fragment('haproxy-00-header').with(
              'target'  => '/etc/haproxy/haproxy.cfg',
              'order'   => '01',
              'content' => "# This file is managed by Puppet\n",
            )
          end
          it 'contains a haproxy-base concat fragment' do
            subject.should contain_concat__fragment('haproxy-haproxy-base').with(
              'target'  => '/etc/haproxy/haproxy.cfg',
              'order'   => '10',
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
        context "when on #{osfamily} family operatingsystems without managing the chroot directory" do
          let(:facts) do
            { osfamily: osfamily }.merge default_facts
          end
          let(:params) do
            {
              'chroot_dir_manage' => false,
            }
          end

          it 'does not manage the haproxy chroot directory' do
            subject.should_not contain_file('/var/lib/haproxy')
          end
        end
        context "on #{osfamily} when specifying a restart_command" do
          let(:facts) do
            { osfamily: osfamily }.merge default_facts
          end
          let(:params) do
            {
              'restart_command' => '/etc/init.d/haproxy reload',
              'service_manage'  => true,
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
  end

  # haproxy::instance with 2nd instance and with non-standard service name.

  context 'when on supported platforms' do
    let(:title) { 'group1' }

    describe 'for OS-agnostic configuration' do
      ['Debian', 'RedHat', 'Archlinux', 'FreeBSD'].each do |osfamily|
        context "on #{osfamily} family operatingsystems" do
          let(:facts) do
            { osfamily: osfamily }.merge default_facts
          end
          let(:params) do
            {
              'service_ensure' => 'running',
              'package_ensure' => 'present',
              'package_name'   => 'customhaproxy',
              'service_manage' => true,
            }
          end

          it 'installs the customhaproxy package' do
            subject.should contain_package('customhaproxy').with(
              'ensure' => 'present',
            )
          end
          it 'installs the customhaproxy service' do
            subject.should contain_service('haproxy-group1').with(
              'ensure' => 'running', 'enable' => 'true',
              'hasrestart' => 'true', 'hasstatus' => 'true'
            )
          end
          it 'does not install the haproxy package' do
            subject.should_not contain_package('haproxy').with(
              'title' => 'haproxy',
            )
          end
          it 'does not install the haproxy service' do
            subject.should_not contain_service('haproxy')
          end
        end
        # C9938
        context "on #{osfamily} when specifying custom content" do
          let(:facts) do
            { osfamily: osfamily }.merge default_facts
          end
          let(:params) do
            { 'custom_fragment' => "listen stats :9090\n  mode http\n  stats uri /\n  stats auth puppet:puppet\n" }
          end

          it 'sets the haproxy-group1 package' do
            subject.should contain_concat__fragment('haproxy-group1-haproxy-base').with_content(
              %r{listen stats :9090\n  mode http\n  stats uri \/\n  stats auth puppet:puppet\n},
            )
          end
        end
      end
    end

    describe 'for linux operating systems' do
      ['Debian', 'RedHat', 'Archlinux'].each do |osfamily|
        context "on #{osfamily} family operatingsystems" do
          let(:facts) do
            { osfamily: osfamily }.merge default_facts
          end

          it 'sets up /etc/haproxy-group1/haproxy-group1.cfg as a concat resource' do
            subject.should contain_concat('/etc/haproxy-group1/haproxy-group1.cfg').with(
              'owner' => '0',
              'group' => '0',
              'mode'  => '0640',
            )
          end
          it 'manages the chroot directory' do
            subject.should contain_file('/var/lib/haproxy').with(
              'ensure' => 'directory',
              'owner'  => 'haproxy',
              'group'  => 'haproxy',
            )
          end
          it 'contains a header concat fragment' do
            subject.should contain_concat__fragment('haproxy-group1-00-header').with(
              'target'  => '/etc/haproxy-group1/haproxy-group1.cfg',
              'order'   => '01',
              'content' => "# This file is managed by Puppet\n",
            )
          end
          it 'contains a haproxy-group1-haproxy-base concat fragment' do
            subject.should contain_concat__fragment('haproxy-group1-haproxy-base').with(
              'target'  => '/etc/haproxy-group1/haproxy-group1.cfg',
              'order'   => '10',
            )
          end
          describe 'Base concat fragment contents' do
            let(:contents) { param_value(catalogue, 'concat::fragment', 'haproxy-group1-haproxy-base', 'content').split("\n") }

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
        context "on #{osfamily} family operatingsystems without managing the service" do
          let(:facts) do
            { osfamily: osfamily }.merge default_facts
          end
          let(:params) do
            {
              'service_ensure' => true,
              'package_ensure' => 'present',
              'package_name'   => 'customhaproxy',
              'service_manage' => false,
            }
          end

          it 'installs the customhaproxy package' do
            subject.should contain_package('customhaproxy').with(
              'ensure' => 'present',
            )
          end
          it 'does not manage the customhaproxy service' do
            subject.should_not contain_service('haproxy-group1')
          end
          it 'sets up /etc/haproxy-group1/haproxy-group1.cfg as a concat resource' do
            subject.should contain_concat('/etc/haproxy-group1/haproxy-group1.cfg').with(
              'owner' => '0',
              'group' => '0',
              'mode'  => '0640',
            )
          end
          it 'manages the chroot directory' do
            subject.should contain_file('/var/lib/haproxy').with(
              'ensure' => 'directory',
            )
          end
          it 'contains a header concat fragment' do
            subject.should contain_concat__fragment('haproxy-group1-00-header').with(
              'target'  => '/etc/haproxy-group1/haproxy-group1.cfg',
              'order'   => '01',
              'content' => "# This file is managed by Puppet\n",
            )
          end
          it 'contains a haproxy-group1-haproxy-base concat fragment' do
            subject.should contain_concat__fragment('haproxy-group1-haproxy-base').with(
              'target'  => '/etc/haproxy-group1/haproxy-group1.cfg',
              'order'   => '10',
            )
          end
          describe 'Base concat fragment contents' do
            let(:contents) { param_value(catalogue, 'concat::fragment', 'haproxy-group1-haproxy-base', 'content').split("\n") }

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
        context "on #{osfamily} when specifying a restart_command" do
          let(:facts) do
            { osfamily: osfamily }.merge default_facts
          end
          let(:params) do
            {
              'restart_command' => '/etc/init.d/haproxy-group1 reload',
              'service_manage'  => true,
            }
          end

          it 'sets the customhaproxy package' do
            subject.should contain_service('haproxy-group1').with(
              'restart' => '/etc/init.d/haproxy-group1 reload',
            )
          end
        end
      end
    end

    # FreeBSD: haproxy::instance with service name "haproxy".

    describe 'for freebsd' do
      let(:title) { 'haproxy' }

      context 'when on freebsd family operatingsystems' do
        let(:facts) do
          { osfamily: 'FreeBSD' }.merge default_facts
        end

        it 'sets up /usr/local/etc/haproxy.conf as a concat resource' do
          subject.should contain_concat('/usr/local/etc/haproxy.conf').with(
            'owner' => '0',
            'group' => '0',
            'mode'  => '0640',
          )
        end
        it 'manages the chroot directory' do
          subject.should contain_file('/usr/local/haproxy').with(
            'ensure' => 'directory',
          )
        end
        it 'contains a header concat fragment' do
          subject.should contain_concat__fragment('haproxy-00-header').with(
            'target'  => '/usr/local/etc/haproxy.conf',
            'order'   => '01',
            'content' => "# This file is managed by Puppet\n",
          )
        end
        it 'contains a haproxy-base concat fragment' do
          subject.should contain_concat__fragment('haproxy-haproxy-base').with(
            'target'  => '/usr/local/etc/haproxy.conf',
            'order'   => '10',
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
          { osfamily: 'FreeBSD' }.merge default_facts
        end
        let(:params) do
          {
            'service_ensure' => true,
            'package_ensure' => 'present',
            'package_name'   => 'haproxy',
            'service_manage' => false,
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
            'mode'  => '0640',
          )
        end
        it 'manages the chroot directory' do
          subject.should contain_file('/usr/local/haproxy').with(
            'ensure' => 'directory',
          )
        end
        it 'contains a header concat fragment' do
          subject.should contain_concat__fragment('haproxy-00-header').with(
            'target'  => '/usr/local/etc/haproxy.conf',
            'order'   => '01',
            'content' => "# This file is managed by Puppet\n",
          )
        end
        it 'contains a haproxy-base concat fragment' do
          subject.should contain_concat__fragment('haproxy-haproxy-base').with(
            'target'  => '/usr/local/etc/haproxy.conf',
            'order'   => '10',
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
          { osfamily: 'FreeBSD' }.merge default_facts
        end
        let(:params) do
          {
            'restart_command' => '/usr/local/etc/rc.d/haproxy reload',
            'service_manage'  => true,
          }
        end

        it 'sets the haproxy package' do
          subject.should contain_service('haproxy').with(
            'restart' => '/usr/local/etc/rc.d/haproxy reload',
          )
        end
      end
    end

    # OS-specific configurations:

    describe 'for OS-specific configuration' do
      context 'when only on Debian family operatingsystems' do
        let(:facts) do
          { osfamily: 'Debian' }.merge default_facts
        end

        it 'manages haproxy service defaults' do
          subject.should contain_file('/etc/default/haproxy-group1')
          verify_contents(catalogue, '/etc/default/haproxy-group1', ['ENABLED=1'])
        end
      end
      context 'when only on Debian family operatingsystems with custom /etc/default' do
        let(:facts) do
          { osfamily: 'Debian' }.merge default_facts
        end
        let(:params) do
          {
            'service_options' => 'stuff',
          }
        end

        it 'manages haproxy service defaults' do
          subject.should contain_file('/etc/default/haproxy-group1')
          verify_contents(catalogue, '/etc/default/haproxy-group1', ['stuff'])
        end
      end
      context 'when only on RedHat family operatingsystems' do
        let(:facts) do
          { osfamily: 'RedHat' }.merge default_facts
        end

        it 'manages haproxy sysconfig options' do
          subject.should contain_file('/etc/sysconfig/haproxy-group1')
          verify_contents(catalogue, '/etc/sysconfig/haproxy-group1', ['OPTIONS=""'])
        end
      end
    end
  end

  # Unsupported OSs:

  context 'when on unsupported operatingsystems' do
    let(:title) { 'haproxy' }
    let(:facts) do
      { osfamily: 'windows' }.merge default_facts
    end

    it do
      expect {
        is_expected.to contain_service('haproxy')
      }.to raise_error(Puppet::Error, %r{operating system is not supported with the haproxy module})
    end
  end
  # rubocop:enable RSpec/NestedGroups
end
