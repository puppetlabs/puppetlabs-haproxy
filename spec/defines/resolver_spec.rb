# frozen_string_literal: true

require 'spec_helper'

describe 'haproxy::resolver' do
  let(:pre_condition) { 'include haproxy' }
  let(:facts) do
    {
      ipaddress: '1.1.1.1',
      concat_basedir: '/dne',
      osfamily: 'RedHat',
    }
  end

  context 'with two resolvers' do
    let(:title) { 'bar' }
    let(:params) do
      {
        nameservers: { 'dns1' => '1.1.1.1:53', 'dns2' => '1.1.1.2:53' },
        hold: { 'other' => '30s', 'refused' => '30s', 'nx' => '30s', 'timeout' => '30s', 'valid' => '10s' },
        resolve_retries: 3,
        timeout: { 'retry' => '1s' },
      }
    end

    it {
      is_expected.to contain_concat__fragment('haproxy-bar_resolver_block').with(
        'order'   => '20-bar-01',
        'target'  => '/etc/haproxy/haproxy.cfg',
        'content' => "\nresolvers bar\n  nameserver dns1 1.1.1.1:53\n  nameserver dns2 1.1.1.2:53\n  resolve_retries 3\n  timeout retry 1s\n  hold other 30s\n  hold refused 30s\n  hold nx 30s\n  hold timeout 30s\n  hold valid 10s\n", # rubocop:disable Layout/LineLength
      )
    }
  end

  context 'with accepted_payload_size within range' do
    let(:title) { 'bar' }
    let(:params) do
      {
        nameservers: { 'dns1' => '1.1.1.1:53', 'dns2' => '1.1.1.2:53' },
        hold: { 'other' => '30s', 'refused' => '30s', 'nx' => '30s', 'timeout' => '30s', 'valid' => '10s' },
        resolve_retries: 3,
        timeout: { 'retry' => '1s' },
        accepted_payload_size: 512,
      }
    end

    it {
      is_expected.to contain_concat__fragment('haproxy-bar_resolver_block').with(
        'order'   => '20-bar-01',
        'target'  => '/etc/haproxy/haproxy.cfg',
        'content' => "\nresolvers bar\n  nameserver dns1 1.1.1.1:53\n  nameserver dns2 1.1.1.2:53\n  resolve_retries 3\n  timeout retry 1s\n  hold other 30s\n  hold refused 30s\n  hold nx 30s\n  hold timeout 30s\n  hold valid 10s\n  accepted_payload_size 512\n", # rubocop:disable Layout/LineLength
      )
    }
  end

  context 'with accepted_payload_size too small' do
    let(:title) { 'bar' }
    let(:params) do
      {
        nameservers: { 'dns1' => '1.1.1.1:53', 'dns2' => '1.1.1.2:53' },
        hold: { 'other' => '30s', 'refused' => '30s', 'nx' => '30s', 'timeout' => '30s', 'valid' => '10s' },
        resolve_retries: 3,
        timeout: { 'retry' => '1s' },
        accepted_payload_size: 511,
      }
    end

    it { is_expected.to compile.and_raise_error(%r{expects a value of type Undef or Integer\[512, 8192\]}) }
  end

  context 'with accepted_payload_size too large' do
    let(:title) { 'bar' }
    let(:params) do
      {
        nameservers: { 'dns1' => '1.1.1.1:53', 'dns2' => '1.1.1.2:53' },
        hold: { 'other' => '30s', 'refused' => '30s', 'nx' => '30s', 'timeout' => '30s', 'valid' => '10s' },
        resolve_retries: 3,
        timeout: { 'retry' => '1s' },
        accepted_payload_size: 8193,
      }
    end

    it { is_expected.to compile.and_raise_error(%r{expects a value of type Undef or Integer\[512, 8192\]}) }
  end
end
