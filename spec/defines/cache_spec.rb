# frozen_string_literal: true

require 'spec_helper'

describe 'haproxy::cache' do
  let :pre_condition do
    'class{"haproxy":
        config_file => "/tmp/haproxy.cfg"
     }
    '
  end
  let(:title) { 'dero' }
  let(:facts) do
    {
      networking: {
        ip: '1.1.1.1',
        hostname: 'dero'
      },
      concat_basedir: '/foo',
      os: {
        family: 'RedHat'
      }
    }
  end

  context 'with a single cache entry' do
    let(:params) do
      {
        total_max_size: 1
      }
    end

    it {
      is_expected.to contain_concat__fragment('haproxy-cache-dero').with(
        'order' => '30-cache-dero',
        'target' => '/tmp/haproxy.cfg',
        'content' => "\ncache dero\n  total-max-size 1\n  max-age 60\n",
      )
    }
  end
end
