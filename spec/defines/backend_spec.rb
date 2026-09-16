# frozen_string_literal: true

require 'spec_helper'

describe 'haproxy::backend' do
  let(:pre_condition) { 'include haproxy' }
  let(:facts) do
    {
      networking: {
        ip: '1.1.1.1'
      },
      os: {
        family: 'Redhat'
      },
      concat_basedir: '/dne'
    }
  end

  context 'when no options are passed' do
    let(:title) { 'bar' }

    it {
      is_expected.to contain_concat__fragment('haproxy-bar_backend_block').with(
        'order' => '20-bar-00',
        'target' => '/etc/haproxy/haproxy.cfg',
        'content' => "\nbackend bar\n  balance roundrobin\n",
      )
    }
  end

  context 'when configurung custom options for stick-tables' do
    let(:title) { 'baz' }
    let(:buzz) { 'type ip size 20k peers mypeers' }
    let(:params) do
      { options: [
        { 'stick-table' => buzz },
        { 'stick' => 'on src' },
      ] }
    end

    it {
      is_expected.to contain_concat__fragment('haproxy-baz_backend_block').with(
        'order' => '20-baz-00',
        'target' => '/etc/haproxy/haproxy.cfg',
        'content' => "\nbackend baz\n  stick-table #{buzz}\n  stick on src\n",
      )
    }
  end

  # C9953
  context 'when a listen is created with the same name' do
    let(:title) { 'apache' }
    let(:pre_condition) do
      "haproxy::listen { 'apache':
         ipaddress => '127.0.0.1',
         ports     => 443,
       }"
    end

    it 'raises error' do
      expect { catalogue }.to raise_error Puppet::Error, %r{discovered with the same name}
    end
  end

  context 'when a non-default config file is used' do
    let(:pre_condition) { 'class { "haproxy": config_file => "/etc/non-default.cfg" }' }
    let(:title) { 'baz' }
    let(:params) do
      {
        options: {
          'balance' => 'roundrobin'
        }
      }
    end

    it {
      is_expected.to contain_concat__fragment('haproxy-baz_backend_block').with(
        'order' => '20-baz-00',
        'target' => '/etc/non-default.cfg',
        'content' => "\nbackend baz\n  balance roundrobin\n",
      )
    }
  end

  # C9956 WONTFIX
end
