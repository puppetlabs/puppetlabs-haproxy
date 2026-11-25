# frozen_string_literal: true

require 'spec_helper'

describe 'haproxy::mapfile' do
  let(:pre_condition) { 'include haproxy' }
  let(:title) { 'domains-to-backends' }
  let(:facts) do
    {
      networking: {
        ip: '1.1.1.1',
      },
      os: {
        family: 'Redhat',
      },
      concat_basedir: '/dne',
    }
  end

  context 'when map domains to backends' do
    let(:params) do
      {
        ensure: 'present',
        mappings: [
          { 'app01.example.com' => 'bk_app01' },
          { 'app02.example.com' => 'bk_app02' },
          { 'app03.example.com' => 'bk_app03' },
          { 'app04.example.com' => 'bk_app04' },
          'app05.example.com bk_app05',
          'app06.example.com bk_app06',
        ],
        instances: ['haproxy'],
      }
    end

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_concat('haproxy_mapfile_domains-to-backends').that_notifies('Haproxy::Service[haproxy]') }

    it {
      is_expected.to contain_concat('haproxy_mapfile_domains-to-backends').with(
        'path' => '/etc/haproxy/domains-to-backends.map',
        'ensure' => 'present',
      )
    }

    it {
      is_expected.to contain_concat__fragment('haproxy_mapfile_domains-to-backends-top').with(
        'order' => '00',
        'target' => '/etc/haproxy/domains-to-backends.map',
        'content' => "app01.example.com bk_app01\napp02.example.com bk_app02\napp03.example.com bk_app03\napp04.example.com bk_app04\napp05.example.com bk_app05\napp06.example.com bk_app06\n",
      )
    }
  end

  context 'when collect domains to backends' do
    let(:params) do
      {
        ensure: 'present',
        instances: ['haproxy'],
      }
    end

    it { is_expected.to compile.with_all_deps }

    it {
      is_expected.to contain_concat__fragment('haproxy_mapfile_domains-to-backends-top').with(
        'order' => '00',
        'target' => '/etc/haproxy/domains-to-backends.map',
        'content' => '',
      )
    }
  end
end
