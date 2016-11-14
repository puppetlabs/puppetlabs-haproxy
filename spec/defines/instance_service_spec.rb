require 'spec_helper'

describe 'haproxy::instance_service' do
  let(:facts) do
    {
      :concat_basedir => '/dne',
      :ipaddress      => '10.10.10.10',
      :osfamily       => 'Debian',
    }
  end
  let(:params) do
    {
      'haproxy_init_source' => 'foo'
    }
  end

  context 'on any platform' do

    # haproxy::instance 'haproxy' with defaults

    context 'with title haproxy and defaults params' do
      let(:title) { 'haproxy' }
      let(:params) do
        {
          'haproxy_init_source' => '/foo/bar'
        }
      end
      it 'should install the haproxy package' do
        subject.should contain_package('haproxy').with(
          'ensure' => 'present'
        )
      end
      it 'should create the exec directory' do
        subject.should contain_file('/opt/haproxy/bin').with(
          'ensure' => 'directory',
          'owner'  => 'root',
          'group'  => 'root',
          'mode'   => '0744'
        )
      end
      it 'should create a link to the exec' do
        subject.should contain_file('/opt/haproxy/bin/haproxy-haproxy').with(
          'ensure' => 'link',
          'target' => '/usr/sbin/haproxy'
        )
      end
      it 'should not create an init.d file' do
        subject.should_not contain_file('/etc/init.d/haproxy-haproxy').with(
          'ensure' => 'file'
        )
      end
    end

  # haproxy::instance 'haproxy' with custom settings

  context 'with title group1 and custom settings' do
    let(:title) { 'haproxy' }
    let(:params) do
      {
        'haproxy_package'     => 'customhaproxy',
        'bindir'              => '/weird/place',
        'haproxy_init_source' => '/foo/bar'
      }
    end
    it 'should install the customhaproxy package' do
      subject.should contain_package('customhaproxy').with(
        'ensure' => 'present'
      )
    end
    it 'should create the exec directory' do
      subject.should contain_file('/weird/place').with(
        'ensure' => 'directory',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0744'
      )
    end
    it 'should create a link to the exec' do
      subject.should contain_file('/weird/place/haproxy-haproxy').with(
        'ensure' => 'link',
        'target' => '/opt/customhaproxy/sbin/haproxy'
      )
    end
    it 'should not create an init.d file' do
      subject.should_not contain_file('/etc/init.d/haproxy-haproxy').with(
        'ensure' => 'file'
      )
    end
    it 'should not manage the default init.d file' do
      subject.should_not contain_file('/etc/init.d/haproxy').with(
        'ensure' => 'file'
      )
    end
  end

  # haproxy::instance 'group1' with defaults

    context 'with title group1 and defaults params' do
      let(:title) { 'group1' }
      let(:params) do
        {
          'haproxy_init_source' => '/foo/bar'
        }
      end
      it 'should install the haproxy package' do
        subject.should contain_package('haproxy').with(
          'ensure' => 'present'
        )
      end
      it 'should create the exec directory' do
        subject.should contain_file('/opt/haproxy/bin').with(
          'ensure' => 'directory',
          'owner'  => 'root',
          'group'  => 'root',
          'mode'   => '0744'
        )
      end
      it 'should create a link to the exec' do
        subject.should contain_file('/opt/haproxy/bin/haproxy-group1').with(
          'ensure' => 'link',
          'target' => '/usr/sbin/haproxy'
        )
      end
      it 'should not create an init.d file' do
        subject.should_not contain_file('/etc/init.d/haproxy-haproxy').with(
          'ensure' => 'file'
        )
      end
    end
  end

  # haproxy::instance 'group1' with custom settings

  context 'with title group1 and defaults params' do
    let(:title) { 'group1' }
    let(:params) do
      {
        'haproxy_package'     => 'customhaproxy',
        'bindir'              => '/weird/place',
        'haproxy_init_source' => '/init/source/haproxy',
        'haproxy_unit_template' => "haproxy/instance_service_unit_example.erb"
      }
    end
    it 'should install the customhaproxy package' do
      subject.should contain_package('customhaproxy').with(
        'ensure' => 'present'
      )
    end
    it 'should create the exec directory' do
      subject.should contain_file('/weird/place').with(
        'ensure' => 'directory',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0744'
      )
    end
    it 'should create a link to the exec' do
      subject.should contain_file('/weird/place/haproxy-group1').with(
        'ensure' => 'link',
        'target' => '/opt/customhaproxy/sbin/haproxy'
      )
    end
    it 'should remove any obsolete init.d file' do
      subject.should contain_file('/etc/init.d/haproxy-group1').with(
        'ensure' => 'absent'
      )
    end
  end

end
