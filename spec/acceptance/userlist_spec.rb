# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'userlist define' do
  pp_one = <<-PUPPETCODE
      class { 'haproxy': }
      haproxy::userlist { 'users_groups':
        users  => [
          'test1 insecure-password elgato',
          'test2 insecure-password elgato',
          '',
        ],
        groups => [
          'g1 users test1',
          '',
        ]
      }

      haproxy::listen { 'app00':
        collect_exported => false,
        ipaddress        => $facts['networking']['interfaces']['lo']['ip'],
        ports            => 5555,
        options          => {
          'mode'         => 'http',
          'acl'          => 'auth_ok http_auth(users_groups)',
          'http-request' => 'auth realm Okay if !auth_ok',
        },
      }
      haproxy::balancermember { 'app00 port 5556':
        listening_service => 'app00',
        server_names      => 'test00.example.com',
        ports             => 5556,
      }

      haproxy::listen { 'app01':
        collect_exported => false,
        ipaddress        => $facts['networking']['interfaces']['lo']['ip'],
        ports            => 5554,
        options          => {
          'mode'         => 'http',
          'acl'          => 'auth_ok http_auth_group(users_groups) g1',
          'http-request' => 'auth realm Okay if !auth_ok',
        },
      }
      haproxy::balancermember { 'app01 port 5556':
        listening_service => 'app01',
        ports             => 5556,
      }
  PUPPETCODE
  it 'is able to configure the listen with puppet' do
    # C9966 C9970
    retry_on_error_matching do
      apply_manifest(pp_one, catch_failures: true)
    end
  end

  # C9957
  it 'test1 should auth as user' do
    expect(run_shell('curl http://test1:elgato@localhost:5555').stdout.chomp).to eq('Response on 5556')
  end

  it 'test2 should auth as user' do
    expect(run_shell('curl http://test2:elgato@localhost:5555').stdout.chomp).to eq('Response on 5556')
  end

  # C9958
  it 'does not auth as user' do
    expect(run_shell('curl http://test3:elgato@localhost:5555').stdout.chomp).not_to eq('Response on 5556')
  end

  # C9959
  it 'auths as group' do
    expect(run_shell('curl http://test1:elgato@localhost:5554').stdout.chomp).to eq('Response on 5556')
  end

  # C9960
  it 'does not auth as group' do
    expect(run_shell('curl http://test2:elgato@localhost:5554').stdout.chomp).not_to eq('Response on 5556')
  end

  # C9965 C9967 C9968 C9969 WONTFIX
end
