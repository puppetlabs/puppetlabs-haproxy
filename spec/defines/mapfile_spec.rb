require 'spec_helper'

describe 'haproxy::mapfile' do
  let(:pre_condition) { 'include haproxy' }
  let(:title) { 'domains-to-backends' }
  let(:facts) do
    {
      :ipaddress      => '1.1.1.1',
      :osfamily       => 'Redhat',
      :concat_basedir => '/dne',
    }
  end
  context "map domains to backends" do
    let(:params) do
      {
        :ensure => 'present',
        :mappings => [
          { 'app01.example.com' => 'bk_app01' },
          { 'app02.example.com' => 'bk_app02' },
          { 'app03.example.com' => 'bk_app03' },
          { 'app04.example.com' => 'bk_app04' },
          'app05.example.com bk_app05',
          'app06.example.com bk_app06',
        ],
        :instances => [ 'haproxy' ],
      }
    end

    it { should contain_file('haproxy_mapfile_domains-to-backends').that_notifies('Haproxy::Service[haproxy]') }
    it { should contain_file('haproxy_mapfile_domains-to-backends').with(
      'path'    => '/etc/haproxy/domains-to-backends.map',
      'ensure'  => 'present',
      'content' => "# HAProxy map file \"domains-to-backends\"\n# Managed by Puppet\n\napp01.example.com bk_app01\napp02.example.com bk_app02\napp03.example.com bk_app03\napp04.example.com bk_app04\napp05.example.com bk_app05\napp06.example.com bk_app06\n" ) }
  end

  context "fail if a non-array is supplied for mappings" do
    let(:params) do
      {
        :ensure => 'present',
        :mappings => { 'foo' => 'bar' },
      }
    end

    it 'should raise error' do
      expect { catalogue }.to raise_error Puppet::Error, /is not an Array/
    end
  end
end
