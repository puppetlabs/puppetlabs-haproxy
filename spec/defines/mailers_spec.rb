# frozen_string_literal: true

require 'spec_helper'

describe 'haproxy::mailers' do
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
      is_expected.to contain_concat__fragment('haproxy-bar_mailers_block').with(
        'order' => '40-mailers-00-bar',
        'target' => '/tmp/haproxy.cfg',
        'content' => "\nmailers bar\n",
      )
    }
  end
end
