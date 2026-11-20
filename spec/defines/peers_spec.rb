# frozen_string_literal: true

require 'spec_helper'

describe 'haproxy::peers' do
  let :pre_condition do
    'class{"haproxy":
        config_file => "/tmp/haproxy.cfg"
     }
    '
  end
  let(:facts) do
    {
      networking: {
        ip: '1.1.1.1',
      },
      concat_basedir: '/foo',
      os: {
        family: 'RedHat',
      },
    }
  end

  context 'when no options are passed' do
    let(:title) { 'bar' }

    it {
      is_expected.to contain_concat__fragment('haproxy-bar_peers_block').with(
        'order' => '30-peers-00-bar',
        'target' => '/tmp/haproxy.cfg',
        'content' => "\npeers bar\n",
      )
    }
  end
end
