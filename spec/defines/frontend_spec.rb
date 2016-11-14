require 'spec_helper'

describe 'haproxy::frontend' do
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

    it { should contain_concat__fragment('haproxy-croy_frontend_block').with(
      'order'   => '15-croy-00',
      'target'  => '/etc/haproxy/haproxy.cfg',
      'content' => "\nfrontend croy\n  bind 1.1.1.1:18140 \n  option tcplog\n"
    ) }
  end
  # C9948 C9947
  context "when an array of ports is provided" do
    let(:params) do
      {
        :name      => 'apache',
        :ipaddress => '23.23.23.23',
        :ports     => [
          '80',
          '443'
        ]
      }
    end

    it { should contain_concat__fragment('haproxy-apache_frontend_block').with(
      'order'   => '15-apache-00',
      'target'  => '/etc/haproxy/haproxy.cfg',
      'content' => "\nfrontend apache\n  bind 23.23.23.23:80 \n  bind 23.23.23.23:443 \n  option tcplog\n"
    ) }
  end
  # C9948
  context "when a comma-separated list of ports is provided" do
    let(:params) do
      {
        :name      => 'apache',
        :ipaddress => '23.23.23.23',
        :ports     => '80,443'
      }
    end

    it { should contain_concat__fragment('haproxy-apache_frontend_block').with(
      'order'   => '15-apache-00',
      'target'  => '/etc/haproxy/haproxy.cfg',
      'content' => "\nfrontend apache\n  bind 23.23.23.23:80 \n  bind 23.23.23.23:443 \n  option tcplog\n"
    ) }
  end
  # C9971
  context "when empty list of ports is provided" do
    let(:params) do
      {
        :name      => 'apache',
        :ipaddress => '23.23.23.23',
        :ports     => [],
      }
    end

    it { should contain_concat__fragment('haproxy-apache_frontend_block').with(
      'order'   => '15-apache-00',
      'target'  => '/etc/haproxy/haproxy.cfg',
      'content' => "\nfrontend apache\n  option tcplog\n"
    ) }
  end
  # C9972
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
  # C9946
  context "when multiple ports are provided greater than 65535" do
    let(:params) do
      {
        :name      => 'apache',
        :ipaddress => '23.23.23.23',
        :ports     => ['80443','80444']
      }
    end

    it 'should raise error' do
      expect { catalogue }.to raise_error Puppet::Error, /outside of range/
    end
  end
  # C9973
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
  # C9949
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
  context "when multiple IPs are provided" do
    let(:params) do
      {
        :name      => 'apache',
        :ipaddress => ['23.23.23.23','23.23.23.24'],
        :ports     => '80'
      }
    end

    it { should contain_concat__fragment('haproxy-apache_frontend_block').with(
      'order'   => '15-apache-00',
      'target'  => '/etc/haproxy/haproxy.cfg',
      'content' => "\nfrontend apache\n  bind 23.23.23.23:80 \n  bind 23.23.23.24:80 \n  option tcplog\n"
    ) }
  end
  context "when bind options are provided" do
    let(:params) do
      {
        :name         => 'apache',
        :ipaddress    => '1.1.1.1',
        :ports        => ['80','8080'],
        :bind_options => [ 'the options', 'go here' ]
      }
    end

    it { should contain_concat__fragment('haproxy-apache_frontend_block').with(
      'order'   => '15-apache-00',
      'target'  => '/etc/haproxy/haproxy.cfg',
      'content' => "\nfrontend apache\n  bind 1.1.1.1:80 the options go here\n  bind 1.1.1.1:8080 the options go here\n  option tcplog\n"
    ) }
  end
  context "when a comma-separated list of ports is provided" do
    let(:params) do
      {
        :name      => 'apache',
        :ipaddress => '23.23.23.23',
        :ports     => '80,443'
      }
    end

    it { should contain_concat__fragment('haproxy-apache_frontend_block').with(
      'order'   => '15-apache-00',
      'target'  => '/etc/haproxy/haproxy.cfg',
      'content' => "\nfrontend apache\n  bind 23.23.23.23:80 \n  bind 23.23.23.23:443 \n  option tcplog\n"
    ) }
  end

  context "when bind parameter is used without ipaddress parameter" do
    let(:params) do
      {
        :name  => 'apache',
        :bind  => {'1.1.1.1:80' => []},
      }
    end
    it { should contain_concat__fragment('haproxy-apache_frontend_block').with(
      'order'   => '15-apache-00',
      'target'  => '/etc/haproxy/haproxy.cfg',
      'content' => "\nfrontend apache\n  bind 1.1.1.1:80 \n  option tcplog\n"
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
    it { should contain_concat__fragment('haproxy-apache_frontend_block').with(
      'order'   => '15-apache-00',
      'target'  => '/etc/haproxy/haproxy.cfg',
      'content' => "\nfrontend apache\n  bind /var/run/ssl-frontend.sock user root mode 600 accept-proxy\n  bind :443,:8443 ssl crt public.puppetlabs.com no-sslv3\n  bind fd@${FD_APP1} \n  bind 1.1.1.1:80 \n  bind 2.2.2.2:8000-8010 ssl crt public.puppetlabs.com\n  option tcplog\n"
    ) }
  end

  context "when bind parameter is used with ip addresses that sort wrong lexigraphically" do
    let(:params) do
      {
        :name  => 'apache',
        :bind  => {
          '10.1.3.21:80'      => [],
          '8.252.206.100:80'  => [],
          '8.252.206.101:80'  => [],
          '8.252.206.99:80'   => [],
          '1.1.1.1:80'        => [],
          ':443,:8443'        => [ 'ssl', 'crt public.puppetlabs.com', 'no-sslv3' ],
          '2.2.2.2:8000-8010' => [ 'ssl', 'crt public.puppetlabs.com' ],
        },
      }
    end
    it { should contain_concat__fragment('haproxy-apache_frontend_block').with(
      'order'   => '15-apache-00',
      'target'  => '/etc/haproxy/haproxy.cfg',
      'content' => "\nfrontend apache\n  bind :443,:8443 ssl crt public.puppetlabs.com no-sslv3\n  bind 1.1.1.1:80 \n  bind 2.2.2.2:8000-8010 ssl crt public.puppetlabs.com\n  bind 8.252.206.99:80 \n  bind 8.252.206.100:80 \n  bind 8.252.206.101:80 \n  bind 10.1.3.21:80 \n  option tcplog\n"
    ) }
  end

  context "when frontend options are specified as an array of hashes" do
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
    it { should contain_concat__fragment('haproxy-apache_frontend_block').with(
      'order'   => '15-apache-00',
      'target'  => '/etc/haproxy/haproxy.cfg',
      'content' => "\nfrontend apache\n  bind 0.0.0.0:48001-48003 \n  mode http\n  reqadd X-Forwarded-Proto:\\ https\n  default_backend dev00_webapp\n  capture request header X-Forwarded-For len 50\n  capture request header Host len 15\n  capture request header Referrer len 15\n  acl dst_dev01 dst_port 48001\n  acl dst_dev02 dst_port 48002\n  acl dst_dev03 dst_port 48003\n  use_backend dev01_webapp if dst_dev01\n  use_backend dev02_webapp if dst_dev02\n  use_backend dev03_webapp if dst_dev03\n  option httplog\n  option http-server-close\n  option forwardfor except 127.0.0.1\n  bind-process all\n  compression algo gzip\n"
    ) }
  end

  context "when defaults parameter is used with option default_backend" do
    let(:params) do
      {
        :name     => 'apache',
        :bind     => {'1.1.1.1:80' => []},
        :defaults => 'test',
        :options  => { 'default_backend' => 'b1' },
      }
    end
    it { should contain_concat__fragment('haproxy-apache_frontend_block').with(
      'order'   => '25-test-b1-00-apache',
      'target'  => '/etc/haproxy/haproxy.cfg',
      'content' => "\nfrontend apache\n  bind 1.1.1.1:80 \n  default_backend b1\n"
    ) }
  end

  context "when configurung custom options for stick-tables" do
    let(:title) { 'baz' }
    let(:buzz) { 'type string len 180 size 32m expire 5m store http_req_rate(10s)' }
    let(:params) do
      { :options => [
          { 'stick-table' => buzz },
          { 'stick' => 'on dst' }]}
    end

    it { should contain_concat__fragment('haproxy-baz_frontend_block').with(
      'order'   => '15-baz-00',
      'target'  => '/etc/haproxy/haproxy.cfg',
      'content' => "\nfrontend baz\n  stick-table #{buzz}\n  stick on dst\n"                                                                                                               
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
        },
      }
    end
    it { should contain_concat__fragment('haproxy-bar_frontend_block').with(
      'order' => '15-bar-00',
      'target' => '/etc/non-default.cfg',
      'content' => "\nfrontend bar\n  bind *:5000 \n  option tcplog\n",
    ) }
  end

  # C9950 C9951 C9952 WONTFIX
end
