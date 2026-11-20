# frozen_string_literal: true

require 'spec_helper'

describe 'haproxy::peer' do
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
        hostname: 'dero',
      },
      concat_basedir: '/foo',
      os: {
        family: 'RedHat',
      },
    }
  end

  context 'with a single peer' do
    let(:params) do
      {
        peers_name: 'tyler',
        port: 1024,
      }
    end

    it {
      is_expected.to contain_concat__fragment('haproxy-peers-tyler-dero').with(
        'order' => '30-peers-01-tyler-dero',
        'target' => '/tmp/haproxy.cfg',
        'content' => "  peer dero 1.1.1.1:1024\n",
      )
    }
  end
end
