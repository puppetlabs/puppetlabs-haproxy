# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'frontend backend defines with defaults' do
  pp_one = <<-PUPPETCODE
      class { 'haproxy::globals':
        sort_options_alphabetic => false,
      }
      class { 'haproxy': }
      haproxy::defaults { 'http':
        options => {
          option => [
            'redispatch',
          ],
          'log'     => 'global',
          retries => 3,
          'timeout client' => '3s',
          'timeout server' => '3s',
          'timeout connect' => '1s',
          'timeout queue' => '10s',
          'timeout check' => '1s',
          'timeout http-request' => '2s',
          balance => 'roundrobin',
          'maxconn' => '8000',

        }
      }
      haproxy::frontend { 'app00':
        ipaddress => '127.0.0.1',
        mode      => 'http',
        ports     => '5555',
        defaults  => 'http',
        options   => { 'default_backend' => 'app00' },
      }
      haproxy::backend { 'app00':
        defaults         => 'http',
        collect_exported => false,
        options          => { 'mode' => 'http' },
      }
      haproxy::balancermember { 'port 5556':
        listening_service => 'app00',
        server_names      => 'test00.example.com',
        defaults          => 'http',
        ports             => '5556',
      }
     haproxy::balancermember { 'port 5557':
        listening_service => 'app00',
        server_names      => 'test01.example.com',
        defaults          => 'http',
        ports             => '5557',
      }
  PUPPETCODE
  it 'is able to configure defaults with puppet' do
    retry_on_error_matching do
      apply_manifest(pp_one, catch_failures: true)
    end
  end

  it 'does a curl against the LB to make sure it gets a response from each port' do
    expect(run_shell('curl localhost:5555').stdout.chomp).to match(%r{Response on 555(6|7)})
  end

  pp_two = <<-PUPPETCODE
      class { 'haproxy::globals':
        sort_options_alphabetic => false,
      }
      class { 'haproxy': }
      haproxy::defaults { 'http':
        options => {
          option => [
            'redispatch',
          ],
          'log'     => 'global',
          retries => 3,
          'timeout client' => '3s',
          'timeout server' => '3s',
          'timeout connect' => '1s',
          'timeout queue' => '10s',
          'timeout check' => '1s',
          'timeout http-request' => '2s',
          balance => 'roundrobin',
          'maxconn' => '8000',

        }
      }
      haproxy::frontend { 'app00':
        ipaddress => '127.0.0.1',
        mode      => 'http',
        ports     => '5555',
        defaults  => 'http',
        options   => { 'default_backend' => 'app00' },
      }
      haproxy::backend { 'app00':
        defaults         => 'http',
        collect_exported => false,
        options          => { 'mode' => 'http' },
      }
      haproxy::balancermember { 'port 5556':
        listening_service => 'app00',
        server_names      => 'test00.example.com',
        defaults          => 'http',
        ports             => '5556',
      }
      haproxy::frontend { 'app01':
        ipaddress => '127.0.0.1',
        mode      => 'http',
        ports     => '6666',
        options   => { 'default_backend' => 'app01' },
      }
      haproxy::backend { 'app01':
        collect_exported => false,
        options          => { 'mode' => 'http' },
      }
      haproxy::balancermember { 'port 5557':
        listening_service => 'app01',
        server_names      => 'test01.example.com',
        ports             => '5557',
      }
  PUPPETCODE
  it 'is able to configure defaults and old style with puppet' do
    retry_on_error_matching do
      apply_manifest(pp_two, catch_failures: true)
    end
  end

  it 'does a curl against the LB to make sure it gets a response from each port #oldstyle' do
    expect(run_shell('curl localhost:5555').stdout.chomp).to match(%r{Response on 5556})
    expect(run_shell('curl localhost:6666').stdout.chomp).to match(%r{Response on 5557})
  end
end
