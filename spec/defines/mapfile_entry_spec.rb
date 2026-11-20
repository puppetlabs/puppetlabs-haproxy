# frozen_string_literal: true

require 'spec_helper'

describe 'haproxy::mapfile::entry' do
  let(:pre_condition) { 'include haproxy' }
  let(:title) { 'example.com example-backend' }
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
        mapfile: 'domains-to-backends',
      }
    end

    it { is_expected.to compile.with_all_deps }

    it {
      is_expected.to contain_concat__fragment('haproxy_mapfile_domains-to-backends-example.com example-backend').with(
        'order' => '10',
        'target' => '/etc/haproxy/domains-to-backends.map',
        'content' => "example.com example-backend\n",
      )
    }
  end
end
