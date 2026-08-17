# frozen_string_literal: true

require 'spec_helper'

describe 'haproxy::http_errors' do
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

  context 'when error files are configured' do
    let(:params) do
      {
        errorfile: {
          400 => '/etc/haproxy/errorfiles/400.http',
          404 => '/etc/haproxy/errorfiles/404.http',
          408 => '/dev/null',
        },
      }
    end
    let(:assertion) do
      <<-CFG

http-errors spec
  errorfile 400 /etc/haproxy/errorfiles/400.http
  errorfile 404 /etc/haproxy/errorfiles/404.http
  errorfile 408 /dev/null
CFG
    end

    it {
      is_expected.to contain_concat__fragment('haproxy-spec_http_errors_block').with(
        'order' => '16-spec-00',
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
        errorfile: {
          404 => '/usr/share/haproxy/errorfiles/404.http',
          503 => '/usr/share/haproxy/errorfiles/503.http',
        },
      }
    end
    let(:assertion) do
      <<-CFG

http-errors bar
  errorfile 404 /usr/share/haproxy/errorfiles/404.http
  errorfile 503 /usr/share/haproxy/errorfiles/503.http
CFG
    end

    it {
      is_expected.to contain_concat__fragment('haproxy-bar_http_errors_block').with(
        'order' => '16-bar-00',
        'target' => '/etc/non-default.cfg',
        'content' => assertion,
      )
    }
  end
end
