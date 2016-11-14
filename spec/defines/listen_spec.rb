require 'spec_helper'

describe 'haproxy::listen' do
  let(:pre_condition) { 'include haproxy' }
  let(:title) { 'tyler' }
  let(:facts) do
    {
      :ipaddress      => '1.1.1.1',
      :osfamily       => 'Redhat',
      :concat_basedir => '/dne',
    }
  end
  context "when only one port is provided" do
    let(:params) do
      {
        :name  => 'croy',
        :ipaddress => '1.1.1.1',
        :ports => '18140'
      }
    end

    it { should contain_concat__fragment('haproxy-croy_listen_block').with(
      'order'   => '20-croy-00',
      'target'  => '/etc/haproxy/haproxy.cfg',
      'content' => "\nlisten croy\n  bind 1.1.1.1:18140 \n  balance roundrobin\n  option tcplog\n"
    ) }
  end
  # C9940
  context "when an array of ports is provided" do
    let(:params) do
      {
        :name      => 'apache',
        :ipaddress => '23.23.23.23',
        :ports     => [
          '80',
          '443',
        ]
      }
    end

    it { should contain_concat__fragment('haproxy-apache_listen_block').with(
      'order'   => '20-apache-00',
      'target'  => '/etc/haproxy/haproxy.cfg',
      'content' => "\nlisten apache\n  bind 23.23.23.23:80 \n  bind 23.23.23.23:443 \n  balance roundrobin\n  option tcplog\n"
    ) }
  end
  # C9940
  context "when a comma-separated list of ports is provided" do
    let(:params) do
      {
        :name      => 'apache',
        :ipaddress => '23.23.23.23',
        :ports     => '80,443'
      }
    end

    it { should contain_concat__fragment('haproxy-apache_listen_block').with(
      'order'   => '20-apache-00',
      'target'  => '/etc/haproxy/haproxy.cfg',
      'content' => "\nlisten apache\n  bind 23.23.23.23:80 \n  bind 23.23.23.23:443 \n  balance roundrobin\n  option tcplog\n"
    ) }
  end
  # C9962
  context "when empty list of ports is provided" do
    let(:params) do
      {
        :name      => 'apache',
        :ipaddress => '23.23.23.23',
        :ports     => [],
      }
    end

    it { should contain_concat__fragment('haproxy-apache_listen_block').with(
      'order'   => '20-apache-00',
      'target'  => '/etc/haproxy/haproxy.cfg',
      'content' => "\nlisten apache\n  balance roundrobin\n  option tcplog\n"
    ) }
  end
  # C9963
  context "when a port is provided greater than 65535" do
    let(:params) do
      {
        :name      => 'apache',
        :ipaddress => '23.23.23.23',
        :ports     => '80443'
      }
    end

    it 'should raise error' do
      expect { catalogue }.to raise_error Puppet::Error, /outside of range/
    end
  end
  # C9974
  context "when an invalid ipv4 address is passed" do
    let(:params) do
      {
        :name      => 'apache',
        :ipaddress => '2323.23.23',
        :ports     => '80'
      }
    end

    it 'should raise error' do
      expect { catalogue }.to raise_error Puppet::Error, /Invalid IP address/
    end
  end
  # C9977
  context "when a valid hostname is passed" do
    let(:params) do
      {
        :name      => 'apache',
        :ipaddress => 'some-hostname',
        :ports     => '80'
      }
    end

    it { should contain_concat__fragment('haproxy-apache_listen_block').with(
      'order'   => '20-apache-00',
      'target'  => '/etc/haproxy/haproxy.cfg',
      'content' => "\nlisten apache\n  bind some-hostname:80 \n  balance roundrobin\n  option tcplog\n"
    ) }
  end
  context "when a * is passed for ip address" do
    let(:params) do
      {
        :name      => 'apache',
        :ipaddress => '*',
        :ports     => '80'
      }
    end

    it { should contain_concat__fragment('haproxy-apache_listen_block').with(
      'order'   => '20-apache-00',
      'target'  => '/etc/haproxy/haproxy.cfg',
      'content' => "\nlisten apache\n  bind *:80 \n  balance roundrobin\n  option tcplog\n"
    ) }
  end
  context "when a bind parameter hash is passed" do
    let(:params) do
      {
        :name      => 'apache',
        :bind      => {'10.0.0.1:333' => ['ssl', 'crt', 'public.puppetlabs.com'], '192.168.122.1:8082' => []},
      }
    end

    it { should contain_concat__fragment('haproxy-apache_listen_block').with(
      'order'   => '20-apache-00',
      'target'  => '/etc/haproxy/haproxy.cfg',
      'content' => "\nlisten apache\n  bind 10.0.0.1:333 ssl crt public.puppetlabs.com\n  bind 192.168.122.1:8082 \n  balance roundrobin\n  option tcplog\n"
    ) }
  end
  context "when a ports parameter and a bind parameter are passed" do
    let(:params) do
      {
        :name  => 'apache',
        :bind  => {'192.168.0.1:80' => ['ssl']},
        :ports => '80'
      }
    end

    it 'should raise error' do
      expect { catalogue }.to raise_error Puppet::Error, /mutually exclusive/
    end
  end
  # C9977
  context "when an invalid hostname is passed" do
    let(:params) do
      {
        :name      => 'apache',
        :ipaddress => '$some_hostname',
        :ports     => '80'
      }
    end

    it 'should raise error' do
      expect { catalogue }.to raise_error Puppet::Error, /Invalid IP address/
    end
  end
  # C9974
  context "when an invalid ipv6 address is passed" do
    let(:params) do
      {
        :name      => 'apache',
        :ipaddress => ':::6',
        :ports     => '80'
      }
    end

    it 'should raise error' do
      expect { catalogue }.to raise_error Puppet::Error, /Invalid IP address/
    end
  end
  context "when bind options are provided" do
    let(:params) do
      {
        :name         => 'apache',
        :ipaddress    => '1.1.1.1',
        :ports        => '80',
        :bind_options => [ 'the options', 'go here' ]
      }
    end

    it { should contain_concat__fragment('haproxy-apache_listen_block').with(
      'order'   => '20-apache-00',
      'target'  => '/etc/haproxy/haproxy.cfg',
      'content' => "\nlisten apache\n  bind 1.1.1.1:80 the options go here\n  balance roundrobin\n  option tcplog\n"
    ) }
  end
  context "when bind parameter is used without ipaddress parameter" do
    let(:params) do
      {
        :name => 'apache',
        :bind => { '1.1.1.1:80' => [] },
      }
    end

    it { should contain_concat__fragment('haproxy-apache_listen_block').with(
      'order'   => '20-apache-00',
      'target'  => '/etc/haproxy/haproxy.cfg',
      'content' => "\nlisten apache\n  bind 1.1.1.1:80 \n  balance roundrobin\n  option tcplog\n"
    ) }
  end

  context "when bind parameter is used with more complex address constructs" do
    let(:params) do
      {
        :name  => 'apache',
        :bind  => {
          '1.1.1.1:80'                 => [],
          ':443,:8443'                 => [ 'ssl', 'crt public.puppetlabs.com', 'no-sslv3' ],
          '2.2.2.2:8000-8010'          => [ 'ssl', 'crt public.puppetlabs.com' ],
          'fd@${FD_APP1}'              => [],
          '/var/run/ssl-frontend.sock' => [ 'user root', 'mode 600', 'accept-proxy' ]
        },
      }
    end
    it { should contain_concat__fragment('haproxy-apache_listen_block').with(
      'order'   => '20-apache-00',
      'target'  => '/etc/haproxy/haproxy.cfg',
      'content' => "\nlisten apache\n  bind /var/run/ssl-frontend.sock user root mode 600 accept-proxy\n  bind :443,:8443 ssl crt public.puppetlabs.com no-sslv3\n  bind fd@${FD_APP1} \n  bind 1.1.1.1:80 \n  bind 2.2.2.2:8000-8010 ssl crt public.puppetlabs.com\n  balance roundrobin\n  option tcplog\n"
    ) }
  end
  context "when bind parameter is used with ip addresses that sort wrong lexigraphically" do
    let(:params) do
      {
        :name  => 'apache',
        :bind  => {
          '10.1.3.21:80'      => 'name input21',
          '8.252.206.100:80'  => 'name input100',
          '8.252.206.101:80'  => 'name input101',
          '8.252.206.99:80'   => 'name input99',
          '1.1.1.1:80'        => [],
          ':443,:8443'        => [ 'ssl', 'crt public.puppetlabs.com', 'no-sslv3' ],
          '2.2.2.2:8000-8010' => [ 'ssl', 'crt public.puppetlabs.com' ],
          'fd@${FD_APP1}'     => [],
        },
      }
    end
    it { should contain_concat__fragment('haproxy-apache_listen_block').with(
      'order'   => '20-apache-00',
      'target'  => '/etc/haproxy/haproxy.cfg',
      'content' => "\nlisten apache\n  bind :443,:8443 ssl crt public.puppetlabs.com no-sslv3\n  bind fd@${FD_APP1} \n  bind 1.1.1.1:80 \n  bind 2.2.2.2:8000-8010 ssl crt public.puppetlabs.com\n  bind 8.252.206.99:80 name input99\n  bind 8.252.206.100:80 name input100\n  bind 8.252.206.101:80 name input101\n  bind 10.1.3.21:80 name input21\n  balance roundrobin\n  option tcplog\n"
    ) }
  end

  context "when listen options are specified as an array of hashes" do
    let(:params) do
      {
        :name => 'apache',
        :bind => {
          '0.0.0.0:48001-48003' => [],
        },
        :mode => 'http',
        :options => [
          { 'reqadd'                 => 'X-Forwarded-Proto:\ https' },
          { 'default_backend'        => 'dev00_webapp' },
          { 'capture request header' => [ 'X-Forwarded-For len 50', 'Host len 15', 'Referrer len 15' ] },
          { 'acl'                    => [ 'dst_dev01 dst_port 48001', 'dst_dev02 dst_port 48002', 'dst_dev03 dst_port 48003' ] },
          { 'use_backend'            => [ 'dev01_webapp if dst_dev01', 'dev02_webapp if dst_dev02', 'dev03_webapp if dst_dev03' ] },
          { 'option'                 => [ 'httplog', 'http-server-close', 'forwardfor except 127.0.0.1' ] },
          { 'compression'            => 'algo gzip',
            'bind-process'           => 'all' }
        ],
      }
    end
    it { should contain_concat__fragment('haproxy-apache_listen_block').with(
      'order'   => '20-apache-00',
      'target'  => '/etc/haproxy/haproxy.cfg',
      'content' => "\nlisten apache\n  bind 0.0.0.0:48001-48003 \n  mode http\n  reqadd X-Forwarded-Proto:\\ https\n  default_backend dev00_webapp\n  capture request header X-Forwarded-For len 50\n  capture request header Host len 15\n  capture request header Referrer len 15\n  acl dst_dev01 dst_port 48001\n  acl dst_dev02 dst_port 48002\n  acl dst_dev03 dst_port 48003\n  use_backend dev01_webapp if dst_dev01\n  use_backend dev02_webapp if dst_dev02\n  use_backend dev03_webapp if dst_dev03\n  option httplog\n  option http-server-close\n  option forwardfor except 127.0.0.1\n  bind-process all\n  compression algo gzip\n"
    ) }
  end

  context "when listen options are specified with sort_options_alphabetic" do
    let(:params) do
      {
        :name => 'apache',
        :bind => {
          '0.0.0.0:48001-48003' => [],
        },
        :mode => 'http',
        :options => {
          'reqadd'                 => 'X-Forwarded-Proto:\ https',
          'reqidel'                => '^X-Forwarded-For:.*',
          'default_backend'        => 'dev00_webapp',
          'capture request header' => [ 'X-Forwarded-For len 50', 'Host len 15', 'Referrer len 15' ],
          'acl'                    => [ 'dst_dev01 dst_port 48001', 'dst_dev02 dst_port 48002', 'dst_dev03 dst_port 48003' ],
          'use_backend'            => [ 'dev01_webapp if dst_dev01', 'dev02_webapp if dst_dev02', 'dev03_webapp if dst_dev03' ],
          'option'                 => [ 'httplog', 'http-server-close', 'forwardfor except 127.0.0.1' ],
          'compression'            => 'algo gzip',
          'bind-process'           => 'all',
        },
      }
    end
    it { should contain_concat__fragment('haproxy-apache_listen_block').with(
      'order'   => '20-apache-00',
      'target'  => '/etc/haproxy/haproxy.cfg',
      'content' => "\nlisten apache\n  bind 0.0.0.0:48001-48003 \n  mode http\n  acl dst_dev01 dst_port 48001\n  acl dst_dev02 dst_port 48002\n  acl dst_dev03 dst_port 48003\n  bind-process all\n  capture request header X-Forwarded-For len 50\n  capture request header Host len 15\n  capture request header Referrer len 15\n  compression algo gzip\n  default_backend dev00_webapp\n  option httplog\n  option http-server-close\n  option forwardfor except 127.0.0.1\n  reqadd X-Forwarded-Proto:\\ https\n  reqidel ^X-Forwarded-For:.*\n  use_backend dev01_webapp if dst_dev01\n  use_backend dev02_webapp if dst_dev02\n  use_backend dev03_webapp if dst_dev03\n"
    ) }
  end

  context "when listen options are specified without sort_options_alphabetic" do
    let(:params) do
      {
        :name => 'apache',
        :bind => {
          '0.0.0.0:48001-48003' => [],
        },
        :mode => 'http',
        :sort_options_alphabetic => false,
        :options => {
          'reqadd'                 => 'X-Forwarded-Proto:\ https',
          'reqidel'                => '^X-Forwarded-For:.*',
          'default_backend'        => 'dev00_webapp',
          'capture request header' => [ 'X-Forwarded-For len 50', 'Host len 15', 'Referrer len 15' ],
          'acl'                    => [ 'dst_dev01 dst_port 48001', 'dst_dev02 dst_port 48002', 'dst_dev03 dst_port 48003' ],
          'use_backend'            => [ 'dev01_webapp if dst_dev01', 'dev02_webapp if dst_dev02', 'dev03_webapp if dst_dev03' ],
          'option'                 => [ 'httplog', 'http-server-close', 'forwardfor except 127.0.0.1' ],
          'compression'            => 'algo gzip',
          'bind-process'           => 'all',
        },
      }
    end
    it { should contain_concat__fragment('haproxy-apache_listen_block').with(
      'order'   => '20-apache-00',
      'target'  => '/etc/haproxy/haproxy.cfg',
      'content' => "\nlisten apache\n  bind 0.0.0.0:48001-48003 \n  mode http\n  acl dst_dev01 dst_port 48001\n  acl dst_dev02 dst_port 48002\n  acl dst_dev03 dst_port 48003\n  bind-process all\n  capture request header X-Forwarded-For len 50\n  capture request header Host len 15\n  capture request header Referrer len 15\n  compression algo gzip\n  default_backend dev00_webapp\n  option httplog\n  option http-server-close\n  option forwardfor except 127.0.0.1\n  reqidel ^X-Forwarded-For:.*\n  reqadd X-Forwarded-Proto:\\ https\n  use_backend dev01_webapp if dst_dev01\n  use_backend dev02_webapp if dst_dev02\n  use_backend dev03_webapp if dst_dev03\n"
    ) }
  end

  context "when a non-default config file is used" do
    let(:pre_condition) { 'class { "haproxy": config_file => "/etc/non-default.cfg" }' }
    let(:params) do
      {
        :name => 'bar',
        :bind => {
          '*:5000' => [],
        },
        :options => {
          'option' => [
            'tcplog',
          ],
          'balance' => 'roundrobin',
        },
      }
    end
    it { should contain_concat__fragment('haproxy-bar_listen_block').with(
      'order' => '20-bar-00',
      'target' => '/etc/non-default.cfg',
      'content' => "\nlisten bar\n  bind *:5000 \n  balance roundrobin\n  option tcplog\n",
    ) }
  end

end
