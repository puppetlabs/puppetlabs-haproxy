# frozen_string_literal: true

require 'spec_helper'

describe 'haproxy::defaults' do
  let :pre_condition do
    'class{"haproxy":
        config_file => "/tmp/haproxy.cfg"
     }
    '
  end
  let(:title) { 'test' }
  let(:facts) do
    {
      networking: {
        ip: '1.1.1.1'
      },
      os: {
        family: 'RedHat'
      },
      concat_basedir: '/dne'
    }
  end

  context 'with a single option' do
    let(:params) do
      {
        options: { 'balance' => 'roundrobin' },
        merge_options: false
      }
    end

    it {
      is_expected.to contain_concat__fragment('haproxy-test_defaults_block').with(
        'order' => '25-test',
        'target' => '/tmp/haproxy.cfg',
        'content' => "\n\ndefaults test\n  balance roundrobin\n",
      )
    }
  end

  context 'with merge defaults true' do
    let(:params) do
      {
        options: { 'balance' => 'roundrobin' }
      }
    end

    defaults_output = <<~EXPECTEDOUTPUT


      defaults test
        balance roundrobin
        log global
        maxconn 8000
        option redispatch
        retries 3
        timeout http-request 10s
        timeout queue 1m
        timeout connect 10s
        timeout client 1m
        timeout server 1m
        timeout check 10s
    EXPECTEDOUTPUT
    it {
      is_expected.to contain_concat__fragment('haproxy-test_defaults_block').with(
        'order' => '25-test',
        'target' => '/tmp/haproxy.cfg',
        'content' => defaults_output,
      )
    }
  end
end
