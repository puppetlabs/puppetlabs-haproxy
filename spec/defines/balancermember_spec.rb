require 'spec_helper'

describe 'haproxy::balancermember' do
  let(:pre_condition) { 'include haproxy' }
  let(:title) { 'tyler' }
  let(:facts) do
    {
      ipaddress: '1.1.1.1',
      hostname: 'dero',
      osfamily: 'Redhat',
      concat_basedir: '/dne',
    }
  end

  context 'with a single balancermember option' do
    let(:params) do
      {
        name: 'tyler',
        listening_service: 'croy',
        ports: '18140',
        options: 'check',
      }
    end

    it {
      is_expected.to contain_concat__fragment('haproxy-croy_balancermember_tyler').with(
        'order'   => '20-croy-01-tyler',
        'target'  => '/etc/haproxy/haproxy.cfg',
        'content' => "  server dero 1.1.1.1:18140 check\n",
      )
    }
  end

  context 'with multiple balancermember options' do
    let(:params) do
      {
        name: 'tyler',
        listening_service: 'croy',
        ports: '18140',
        options: ['check', 'close'],
      }
    end

    it {
      is_expected.to contain_concat__fragment('haproxy-croy_balancermember_tyler').with(
        'order'   => '20-croy-01-tyler',
        'target'  => '/etc/haproxy/haproxy.cfg',
        'content' => "  server dero 1.1.1.1:18140 check close\n",
      )
    }
  end

  context 'with cookie and multiple balancermember options' do
    let(:params) do
      {
        name: 'tyler',
        listening_service: 'croy',
        ports: '18140',
        options: ['check', 'close'],
        define_cookies: true,
      }
    end

    it {
      is_expected.to contain_concat__fragment('haproxy-croy_balancermember_tyler').with(
        'order'   => '20-croy-01-tyler',
        'target'  => '/etc/haproxy/haproxy.cfg',
        'content' => "  server dero 1.1.1.1:18140 cookie dero check close\n",
      )
    }
  end

  context 'with verifyhost' do
    let(:params) do
      {
        name: 'tyler',
        listening_service: 'croy',
        ports: '18140',
        options: ['check', 'close'],
        verifyhost: true,
      }
    end

    it {
      is_expected.to contain_concat__fragment('haproxy-croy_balancermember_tyler').with(
        'order'   => '20-croy-01-tyler',
        'target'  => '/etc/haproxy/haproxy.cfg',
        'content' => "  server dero 1.1.1.1:18140 check close verifyhost dero\n",
      )
    }
  end
  context 'with multiple servers' do
    let(:params) do
      {
        name: 'tyler',
        listening_service: 'croy',
        ports: '18140',
        server_names: ['server01', 'server02'],
        ipaddresses: ['192.168.56.200', '192.168.56.201'],
        options: ['check'],
      }
    end

    it {
      is_expected.to contain_concat__fragment('haproxy-croy_balancermember_tyler').with(
        'order'   => '20-croy-01-tyler',
        'target'  => '/etc/haproxy/haproxy.cfg',
        'content' => "  server server01 192.168.56.200:18140 check\n  server server02 192.168.56.201:18140 check\n",
      )
    }
  end
  context 'with multiple servers and multiple ports' do
    let(:params) do
      {
        name: 'tyler',
        listening_service: 'croy',
        ports: ['18140', '18150'],
        server_names: ['server01', 'server02'],
        ipaddresses: ['192.168.56.200', '192.168.56.201'],
        options: ['check'],
      }
    end

    it {
      is_expected.to contain_concat__fragment('haproxy-croy_balancermember_tyler').with(
        'order'   => '20-croy-01-tyler',
        'target'  => '/etc/haproxy/haproxy.cfg',
        'content' => "  server server01 192.168.56.200:18140 check\n  server server01 192.168.56.200:18150 check\n  server server02 192.168.56.201:18140 check\n  server server02 192.168.56.201:18150 check\n", # rubocop:disable Metrics/LineLength
      )
    }
  end
  context 'with multiple servers and no port' do
    let(:params) do
      {
        name: 'tyler',
        listening_service: 'croy',
        server_names: ['server01', 'server02'],
        ipaddresses: ['192.168.56.200', '192.168.56.201'],
        options: ['check'],
      }
    end

    it {
      is_expected.to contain_concat__fragment('haproxy-croy_balancermember_tyler').with(
        'order'   => '20-croy-01-tyler',
        'target'  => '/etc/haproxy/haproxy.cfg',
        'content' => "  server server01 192.168.56.200 check\n  server server02 192.168.56.201 check\n",
      )
    }
  end
  context 'when a non-default config file is used' do
    let(:pre_condition) { 'class { "haproxy": config_file => "/etc/non-default.cfg" }' }
    let(:params) do
      {
        name: 'haproxy',
        listening_service: 'baz',
        server_names: ['server01', 'server02'],
        ipaddresses: ['10.0.0.1', '10.0.0.2'],
        options: ['check'],
      }
    end

    it {
      is_expected.to contain_concat__fragment('haproxy-baz_balancermember_haproxy').with(
        'order' => '20-baz-01-haproxy',
        'target' => '/etc/non-default.cfg',
        'content' => "  server server01 10.0.0.1 check\n  server server02 10.0.0.2 check\n",
      )
    }
  end
  context 'with weight' do
    let(:params) do
      {
        name: 'tyler',
        listening_service: 'croy',
        ports: '18140',
        options: 'check',
        weight: '100',
      }
    end

    it {
      is_expected.to contain_concat__fragment('haproxy-croy_balancermember_tyler').with(
        'order'   => '20-croy-01-tyler',
        'target'  => '/etc/haproxy/haproxy.cfg',
        'content' => "  server dero 1.1.1.1:18140 check weight 100\n",
      )
    }
  end

  context 'server-template' do
    let(:params) do
      {
        name: 'tyler',
        type: 'server-template',
        listening_service: 'croy',
        fqdn: 'myserver.example.local',
      }
    end

    it {
      is_expected.to contain_concat__fragment('haproxy-croy_balancermember_tyler').with(
        'order'   => '20-croy-01-tyler',
        'target'  => '/etc/haproxy/haproxy.cfg',
        'content' => "  server-template server 1 myserver.example.local \n",
      )
    }
  end

  context 'server-template with port' do
    let(:params) do
      {
        name: 'tyler',
        type: 'server-template',
        listening_service: 'croy',
        fqdn: 'myserver.example.local',
        port: '8080',
      }
    end

    it {
      is_expected.to contain_concat__fragment('haproxy-croy_balancermember_tyler').with(
        'order'   => '20-croy-01-tyler',
        'target'  => '/etc/haproxy/haproxy.cfg',
        'content' => "  server-template server 1 myserver.example.local:8080 \n",
      )
    }
  end

  context 'server-template with port with num amount' do
    let(:params) do
      {
        name: 'tyler',
        type: 'server-template',
        listening_service: 'croy',
        fqdn: 'myserver.example.local',
        port: '8080',
        amount: '5',
      }
    end

    it {
      is_expected.to contain_concat__fragment('haproxy-croy_balancermember_tyler').with(
        'order'   => '20-croy-01-tyler',
        'target'  => '/etc/haproxy/haproxy.cfg',
        'content' => "  server-template server 5 myserver.example.local:8080 \n",
      )
    }
  end

  context 'server-template with port with range amount' do
    let(:params) do
      {
        name: 'tyler',
        type: 'server-template',
        listening_service: 'croy',
        fqdn: 'myserver.example.local',
        port: '8080',
        amount: '1-10',
      }
    end

    it {
      is_expected.to contain_concat__fragment('haproxy-croy_balancermember_tyler').with(
        'order'   => '20-croy-01-tyler',
        'target'  => '/etc/haproxy/haproxy.cfg',
        'content' => "  server-template server 1-10 myserver.example.local:8080 \n",
      )
    }
  end

  context 'server-template with port with range amount with server prefix' do
    let(:params) do
      {
        name: 'tyler',
        type: 'server-template',
        listening_service: 'croy',
        fqdn: 'myserver.example.local',
        port: '8080',
        amount: '1-10',
        prefix: 'srv',
      }
    end

    it {
      is_expected.to contain_concat__fragment('haproxy-croy_balancermember_tyler').with(
        'order'   => '20-croy-01-tyler',
        'target'  => '/etc/haproxy/haproxy.cfg',
        'content' => "  server-template srv 1-10 myserver.example.local:8080 \n",
      )
    }
  end

  context 'server-template with port with range amount with server prefix with options' do
    let(:params) do
      {
        name: 'tyler',
        type: 'server-template',
        listening_service: 'croy',
        fqdn: 'myserver.example.local',
        port: '8080',
        amount: '1-10',
        prefix: 'srv',
        options: 'check',
      }
    end

    it {
      is_expected.to contain_concat__fragment('haproxy-croy_balancermember_tyler').with(
        'order'   => '20-croy-01-tyler',
        'target'  => '/etc/haproxy/haproxy.cfg',
        'content' => "  server-template srv 1-10 myserver.example.local:8080 check\n",
      )
    }
  end

  context 'server-template with port with range amount with server prefix with multiple options' do
    let(:params) do
      {
        name: 'tyler',
        type: 'server-template',
        listening_service: 'croy',
        fqdn: 'myserver.example.local',
        port: '8080',
        amount: '1-10',
        prefix: 'srv',
        options: ['check', 'close'],
      }
    end

    it {
      is_expected.to contain_concat__fragment('haproxy-croy_balancermember_tyler').with(
        'order'   => '20-croy-01-tyler',
        'target'  => '/etc/haproxy/haproxy.cfg',
        'content' => "  server-template srv 1-10 myserver.example.local:8080 check close\n",
      )
    }
  end

  context 'server-template with port with range amount with server prefix with options with weight' do
    let(:params) do
      {
        name: 'tyler',
        type: 'server-template',
        listening_service: 'croy',
        fqdn: 'myserver.example.local',
        port: '8080',
        amount: '1-10',
        prefix: 'srv',
        options: 'check',
        weight: 100,
      }
    end

    it {
      is_expected.to contain_concat__fragment('haproxy-croy_balancermember_tyler').with(
        'order'   => '20-croy-01-tyler',
        'target'  => '/etc/haproxy/haproxy.cfg',
        'content' => "  server-template srv 1-10 myserver.example.local:8080 check weight 100\n",
      )
    }
  end

  context 'server-template with port with range amount with server prefix with options with weight with cookies' do
    let(:params) do
      {
        name: 'tyler',
        type: 'server-template',
        listening_service: 'croy',
        fqdn: 'myserver.example.local',
        port: '8080',
        amount: '1-10',
        prefix: 'srv',
        options: 'check',
        weight: 100,
        define_cookies: true,
      }
    end

    it {
      is_expected.to contain_concat__fragment('haproxy-croy_balancermember_tyler').with(
        'order'   => '20-croy-01-tyler',
        'target'  => '/etc/haproxy/haproxy.cfg',
        'content' => "  server-template srv 1-10 myserver.example.local:8080 cookie myserver.example.local check weight 100\n",
      )
    }
  end

  context 'server-template with port with range amount with server prefix with options with weight with cookies with verifyhost' do
    let(:params) do
      {
        name: 'tyler',
        type: 'server-template',
        listening_service: 'croy',
        fqdn: 'myserver.example.local',
        port: '8080',
        amount: '1-10',
        prefix: 'srv',
        options: 'check',
        weight: 100,
        define_cookies: true,
        verifyhost: true,
      }
    end

    it {
      is_expected.to contain_concat__fragment('haproxy-croy_balancermember_tyler').with(
        'order'   => '20-croy-01-tyler',
        'target'  => '/etc/haproxy/haproxy.cfg',
        'content' => "  server-template srv 1-10 myserver.example.local:8080 cookie myserver.example.local check verifyhost myserver.example.local weight 100\n",
      )
    }
  end
end
