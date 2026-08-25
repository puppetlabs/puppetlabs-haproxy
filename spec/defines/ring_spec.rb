# frozen_string_literal: true

require 'spec_helper'

describe 'haproxy::ring' do
  let(:pre_condition) { 'include haproxy' }
  let(:title) { 'spec' }
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

  context 'when a server is configured' do
    let(:params) do
      {
        server: {
          'mysyslogsrv' => '127.0.0.1:6514 log-proto octet-count',
        },
      }
    end
    let(:assertion) do
      <<-CFG

ring spec
  server mysyslogsrv 127.0.0.1:6514 log-proto octet-count
CFG
    end

    it {
      is_expected.to contain_concat__fragment('haproxy-spec_ring_block').with(
        'order' => '17-spec-00',
        'target' => '/etc/haproxy/haproxy.cfg',
        'content' => assertion,
      )
    }
  end

  context 'when timeouts are configured' do
    let(:params) do
      {
        timeout: {
          'connect' => '10',
          'resolve' => '3s',
        },
      }
    end
    let(:assertion) do
      <<-CFG

ring spec
  timeout connect 10
  timeout resolve 3s
CFG
    end

    it {
      is_expected.to contain_concat__fragment('haproxy-spec_ring_block').with(
        'order' => '17-spec-00',
        'target' => '/etc/haproxy/haproxy.cfg',
        'content' => assertion,
      )
    }
  end

  context 'when a non-default config file is used' do
    let(:pre_condition) { 'class { "haproxy": config_file => "/etc/non-default.cfg" }' }
    let(:params) do
      {
        name: 'bar',
        format: 'rfc3164',
      }
    end
    let(:assertion) do
      <<-CFG

ring bar
  format rfc3164
CFG
    end

    it {
      is_expected.to contain_concat__fragment('haproxy-bar_ring_block').with(
        'order' => '17-bar-00',
        'target' => '/etc/non-default.cfg',
        'content' => assertion,
      )
    }
  end
end
