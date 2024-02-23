# frozen_string_literal: true

require 'spec_helper'

describe 'haproxy::program' do
  let :pre_condition do
    'class{"haproxy":
        config_file => "/tmp/haproxy.cfg"
     }
    '
  end
  let(:facts) do
    {
      concat_basedir: '/foo',
      os: {
        family: 'Debian'
      }
    }
  end

  context 'simple program' do
    let(:title) { 'hello' }
    let(:params) do
      {
        command: 'echo "hello world"',
      }
    end

    it {
      is_expected.to contain_concat__fragment('haproxy-hello_program').with(
        'order' => '40-program-hello',
        'target' => '/tmp/haproxy.cfg',
        'content' => %r{command echo "hello world"},
      )
    }
  end
end
