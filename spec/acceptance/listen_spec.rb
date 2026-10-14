# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'listen define' do
  context 'with standard setup' do
    pp_one = <<-PUPPETCODE
        class { 'haproxy': }
        haproxy::listen { 'app00':
          ipaddress => '127.0.0.1',
          ports     => 5555,
          mode      => 'http',
        }
        haproxy::balancermember { 'port 5556':
          listening_service => 'app00',
          server_names      => 'test00.example.com',
          ports             => 5556,
        }
        haproxy::balancermember { 'port 5557':
          listening_service => 'app00',
          server_names      => 'test01.example.com',
          ports             => 5557,
        }
    PUPPETCODE
    it 'is able to configure the listen with puppet' do
      retry_on_error_matching do
        apply_manifest(pp_one, catch_failures: true)
      end
    end

    # This is not great since it depends on the ordering served by the load
    # balancer. Something with retries would be better.
    # C9876 C9877 C9941 C9954
    it 'does a curl against the LB to make sure it gets a response from each port' do
      expect(run_shell('curl localhost:5555').stdout.chomp).to match(%r{Response on 555(6|7)})
    end
  end

  context 'with options' do
    # C9955
    pp_two = <<-PUPPETCODE
        class { 'haproxy': }
        haproxy::listen { 'app00':
          ipaddress => '127.0.0.1',
          ports     => 5555,
          mode      => 'http',
          options   => { 'option' => 'httpchk', },
        }
        haproxy::balancermember { 'port 5556':
          listening_service => 'app00',
          server_names      => 'test00.example.com',
          ports             => 5556,
        }
        haproxy::balancermember { 'port 5557':
          listening_service => 'app00',
          server_names      => 'test01.example.com',
          ports             => 5557,
          options           => ['check','backup'],
        }
    PUPPETCODE
    it 'is able to configure the listen active/passive' do
      retry_on_error_matching do
        idempotent_apply(pp_two)
      end
    end

    it 'does a curl against the LB to make sure it only gets a response from the active port' do
      expect(run_shell('curl localhost:5555').stdout.chomp).to match(%r{Response on 555(6|7)})
    end
  end
  # C9942 C9944 WONTFIX

  context 'with one node up' do
    # C9943
    pp_three = <<-PUPPETCODE
        class { 'haproxy': }
        haproxy::listen { 'app00':
          ipaddress => '127.0.0.1',
          ports     => 5555,
          mode      => 'http',
        }
        haproxy::balancermember { 'port 5556':
          listening_service => 'app00',
          server_names      => 'test00.example.com',
          ports             => 5556,
        }
        haproxy::balancermember { 'port 5557':
          listening_service => 'app00',
          server_names      => 'test01.example.com',
          ports             => 5558,
        }
    PUPPETCODE
    it 'is able to configure the listen with only one node up' do
      retry_on_error_matching do
        apply_manifest(pp_three, catch_failures: true)
      end
    end

    it 'does a curl against the LB to make sure it gets a response from each port #onenodeup' do
      expect(run_shell('curl localhost:5555').stdout.chomp).to match(%r{Response on 555(6|7)})
    end
  end

  context 'with no addess' do
    pp_four = <<-PUPPETCODE
        class { 'haproxy': }
          haproxy::listen { 'app0':
          bind =>
            { '127.0.0.1:5555' => [] }
          }
    PUPPETCODE
    it 'having no address set but setting bind' do
      retry_on_error_matching do
        apply_manifest(pp_four, catch_failures: true)
      end
    end
  end
end
