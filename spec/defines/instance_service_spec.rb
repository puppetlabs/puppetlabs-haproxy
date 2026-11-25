# frozen_string_literal: true

require 'spec_helper'

describe 'haproxy::instance_service' do
  let(:facts) do
    {
      concat_basedir: '/dne',
      networking: {
        ip: '10.10.10.10',
      },
      os: {
        family: 'Debian',
      },
    }
  end
  let(:params) do
    {
      'haproxy_init_source' => 'foo',
    }
  end

  context 'when on any platform' do
    # haproxy::instance 'haproxy' with defaults

    context 'with title haproxy and defaults params' do
      let(:title) { 'haproxy' }
      let(:params) do
        {
          'haproxy_init_source' => '/foo/bar',
        }
      end

      it 'installs the haproxy package' do
        subject.should contain_package('haproxy').with(
          'ensure' => 'present',
        )
      end

      it 'creates the exec directory' do
        subject.should contain_file('/opt/haproxy/bin').with(
          'ensure' => 'directory', 'owner' => 'root',
          'group' => 'root', 'mode' => '0744'
        )
      end

      it 'creates a link to the exec' do
        subject.should contain_file('/opt/haproxy/bin/haproxy-haproxy').with(
          'ensure' => 'link',
          'target' => '/usr/sbin/haproxy',
        )
      end

      it 'does not create an init.d file' do
        subject.should_not contain_file('/etc/init.d/haproxy-haproxy').with(
          'ensure' => 'file',
        )
      end
    end

    # haproxy::instance 'haproxy' with custom settings

    context 'with title group1 and custom settings' do
      let(:title) { 'haproxy' }
      let(:pre_condition) do
        <<-PUPPETCODE
        service {'haproxy-#{title}': }
        PUPPETCODE
      end
      let(:params) do
        {
          'haproxy_package' => 'customhaproxy',
          'bindir' => '/weird/place',
          'haproxy_init_source' => '/foo/bar',
        }
      end

      it 'installs the customhaproxy package' do
        subject.should contain_package('customhaproxy').with(
          'ensure' => 'present',
        )
      end

      it 'creates the exec directory' do
        subject.should contain_file('/weird/place').with(
          'ensure' => 'directory', 'owner' => 'root',
          'group' => 'root', 'mode' => '0744'
        )
      end

      it 'creates a link to the exec' do
        subject.should contain_file('/weird/place/haproxy-haproxy').with(
          'ensure' => 'link',
          'target' => '/opt/customhaproxy/sbin/haproxy',
        )
      end

      it 'does not create an init.d file' do
        subject.should_not contain_file('/etc/init.d/haproxy-haproxy').with(
          'ensure' => 'file',
        )
      end

      it 'does not manage the default init.d file' do
        subject.should_not contain_file('/etc/init.d/haproxy').with(
          'ensure' => 'file',
        )
      end
    end

    # haproxy::instance 'group1' with defaults

    context 'with title group1 and defaults params' do
      let(:title) { 'group1' }
      let(:pre_condition) do
        <<-PUPPETCODE
        service {'haproxy-#{title}': }
        PUPPETCODE
      end
      let(:params) do
        {
          'haproxy_init_source' => '/foo/bar',
        }
      end

      it 'installs the haproxy package' do
        subject.should contain_package('haproxy').with(
          'ensure' => 'present',
        )
      end

      it 'creates the exec directory' do
        subject.should contain_file('/opt/haproxy/bin').with(
          'ensure' => 'directory', 'owner' => 'root',
          'group' => 'root', 'mode' => '0744'
        )
      end

      it 'creates a link to the exec' do
        subject.should contain_file('/opt/haproxy/bin/haproxy-group1').with(
          'ensure' => 'link',
          'target' => '/usr/sbin/haproxy',
        )
      end

      it 'does not create an init.d file' do
        subject.should_not contain_file('/etc/init.d/haproxy-haproxy').with(
          'ensure' => 'file',
        )
      end
    end
  end

  # haproxy::instance 'group1' with custom settings

  context 'with title group1 and defaults params' do
    let(:title) { 'group1' }
    let(:pre_condition) do
      <<-PUPPETCODE
        service {'haproxy-#{title}': }
      PUPPETCODE
    end
    let(:params) do
      {
        'haproxy_package' => 'customhaproxy',
        'bindir' => '/weird/place',
        'haproxy_init_source' => '/init/source/haproxy',
      }
    end

    it 'installs the customhaproxy package' do
      subject.should contain_package('customhaproxy').with(
        'ensure' => 'present',
      )
    end

    it 'creates the exec directory' do
      subject.should contain_file('/weird/place').with(
        'ensure' => 'directory', 'owner' => 'root',
        'group' => 'root', 'mode' => '0744'
      )
    end

    it 'creates a link to the exec' do
      subject.should contain_file('/weird/place/haproxy-group1').with(
        'ensure' => 'link',
        'target' => '/opt/customhaproxy/sbin/haproxy',
      )
    end

    it 'removes any obsolete init.d file' do
      subject.should contain_file('/etc/init.d/haproxy-group1').with(
        'ensure' => 'absent',
      )
    end
  end
end
